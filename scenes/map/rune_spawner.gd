class_name RuneSpawner
extends Area3D

## Spawns Power Runes (River) and Bounty Runes (Jungle)

enum RuneType {
	POWER, # River runes: Haste, Double Damage, Regen, Invisibility
	BOUNTY # Jungle runes: Team gold
}

@export var rune_type: RuneType = RuneType.POWER
@export var respawn_interval: float = 120.0 # 2 minutes

var is_rune_active: bool = true
var respawn_timer: float = 0.0

func _ready() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var sphere = SphereShape3D.new()
		sphere.radius = 1.5
		col.shape = sphere
		add_child(col)
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if not is_rune_active:
		respawn_timer -= delta
		if respawn_timer <= 0.0:
			is_rune_active = true
			visible = true

func _on_body_entered(body: Node3D) -> void:
	if not is_rune_active:
		return
		
	if body is HeroEntity and body.is_alive():
		_grant_rune_effect(body as HeroEntity)
		is_rune_active = false
		visible = false
		respawn_timer = respawn_interval

func _grant_rune_effect(hero: HeroEntity) -> void:
	if rune_type == RuneType.BOUNTY:
		hero.inventory_manager.add_gold(100)
	else:
		# Power rune: +30% Move Speed and +25 AD buff for 20s
		var rune_buff = StatusEffect.new("rune_power_haste", StatusEffect.EffectType.BUFF, 20.0)
		hero.effect_container.apply_effect(rune_buff)
		
		var mod_ms = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.30, "rune_power_haste", 20.0)
		var mod_ad = StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, 25.0, "rune_power_haste", 20.0)
		hero.attribute_system.add_modifier(mod_ms)
		hero.attribute_system.add_modifier(mod_ad)
