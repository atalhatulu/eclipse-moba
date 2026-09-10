class_name MalakorHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Implementation of Malakor (The High Tactician / STR Field Marshal)
## Commands army formations: Advance & Charge, Hold the Line, Focus Fire, and Royal Vanguard.

signal advance_charged(origin: Vector3, dest: Vector3, allies_rallied: int)
signal line_held(armor_bonus: float)
signal focus_fire_marked(target: BaseCombatEntity)
signal royal_vanguard_deployed(target_point: Vector3, enemies_hit: int)

var malakor_visual_root: Node3D = null
var war_banner: MeshInstance3D = null

# W: Hold the Line State
var is_holding_line: bool = false
var hold_timer: float = 0.0

func _ready() -> void:
	entity_name = "Malakor"
	hero_resource = MalakorDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_malakor_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.60
		shape.height = 2.1
		col.shape = shape
		col.position.y = 1.05
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("MalakorVisual"):
		malakor_visual_root = Node3D.new()
		malakor_visual_root.name = "MalakorVisual"
		add_child(malakor_visual_root)
		
		# Armored Field Marshal Body
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.52
		body_capsule.height = 2.05
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.02
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.45, 0.18, 0.15, 1.0) # Imperial Crimson Plate
		mat.metallic = 0.75
		mat.roughness = 0.35
		body_inst.material_override = mat
		malakor_visual_root.add_child(body_inst)
		
		# Tactical War Banner on Back
		war_banner = MeshInstance3D.new()
		var banner_mesh = BoxMesh.new()
		banner_mesh.size = Vector3(0.12, 1.8, 0.75)
		war_banner.mesh = banner_mesh
		war_banner.position = Vector3(0.0, 1.6, -0.45)
		
		var b_mat = StandardMaterial3D.new()
		b_mat.albedo_color = Color(0.85, 0.72, 0.25, 1.0) # Gold Inlaid Banner
		b_mat.metallic = 0.40
		war_banner.material_override = b_mat
		malakor_visual_root.add_child(war_banner)
	else:
		malakor_visual_root = get_node_or_null("MalakorVisual")

func _apply_malakor_definition() -> void:
	if hero_resource == null:
		hero_resource = MalakorDefinition.create_resource()
		
	var def = hero_resource
	attribute_system.primary_attribute = def.primary_attribute
	attribute_system.base_strength = def.base_strength
	attribute_system.strength_growth = def.strength_growth
	attribute_system.base_agility = def.base_agility
	attribute_system.agility_growth = def.agility_growth
	attribute_system.base_intelligence = def.base_intelligence
	attribute_system.intelligence_growth = def.intelligence_growth
	
	attribute_system.base_health = def.base_health
	attribute_system.base_health_regen = def.base_health_regen
	attribute_system.base_mana = def.base_mana
	attribute_system.base_mana_regen = def.base_mana_regen
	attribute_system.base_attack_damage = def.base_attack_damage
	attribute_system.base_ability_power = def.base_ability_power
	attribute_system.base_armor = def.base_armor
	attribute_system.base_magic_resist = def.base_magic_resist
	attribute_system.base_attack_speed = def.base_attack_speed
	attribute_system.base_move_speed = def.base_move_speed
	attribute_system.base_attack_range = def.base_attack_range
	
	attribute_system.current_health = def.base_health
	attribute_system.current_mana = def.base_mana
	attribute_system.recalculate_all_stats()
	
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

func _process(delta: float) -> void:
	super._process(delta)
	_process_hold(delta)

func _process_hold(delta: float) -> void:
	if not is_holding_line:
		return
	hold_timer -= delta
	if hold_timer <= 0.0:
		is_holding_line = false
		attribute_system.remove_modifiers_by_source("malakor_hold_line")

# --- Q: ADVANCE & CHARGE (DIRECTIONAL CHARGE + ALLY RALLY) ---
func cast_malakor_q(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio)
	
	var cur_pos = global_position if is_inside_tree() else position
	var dir = (target_point - cur_pos).normalized()
	dir.y = 0.0
	if dir.length_squared() < 0.001:
		dir = -transform.basis.z.normalized()
		
	var charge_dist = minf(6.0, cur_pos.distance_to(target_point))
	if charge_dist < 1.0:
		charge_dist = 5.0
	var dest = cur_pos + dir * charge_dist
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, null, target_point):
		return false
		
	if is_inside_tree():
		global_position = dest
	else:
		position = dest
		
	var hit_count := 0
	var allies_rallied := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive():
				if entity.team != team:
					var dist_to_line = (entity.global_position - cur_pos).cross(dir).length()
					if dist_to_line <= 2.2:
						var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Advance & Charge")
						CombatCalculator.execute_damage(req)
						hit_count += 1
				else:
					# Rally allies
					if cur_pos.distance_to(entity.global_position) <= 6.0:
						if "effect_container" in entity and entity.effect_container != null:
							var rally = StatusEffect.new("malakor_rally_speed", StatusEffect.EffectType.STAT_MODIFIER, 3.0, 45.0, false)
							rally.target_stat = StatModifier.TargetStat.MOVE_SPEED
							rally.stat_mod_type = StatModifier.Type.FLAT
							entity.effect_container.apply_effect(rally)
							allies_rallied += 1
							
	advance_charged.emit(cur_pos, dest, allies_rallied)
	return true

# --- W: HOLD THE LINE (SELF BUFF + DEFENSIVE WALL) ---
func cast_malakor_w() -> bool:
	if not can_cast():
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var shield_val = 150.0 + (lvl * 60.0)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	is_holding_line = true
	hold_timer = 4.0
	
	var armor_mod = StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, 30.0, "malakor_hold_line")
	attribute_system.add_modifier(armor_mod)
	CombatMechanicsClass.apply_shield(self, self, "malakor_hold_shield", "Mevzi Kalkanı", shield_val, 4.0)
	
	line_held.emit(30.0)
	return true

# --- E: FOCUS FIRE (TARGETED TACTICAL MARK) ---
func cast_malakor_e(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * e_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.E, target):
		return false
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Focus Fire")
	CombatCalculator.execute_damage(req)
	
	# Mark target to take increased damage
	if "effect_container" in target and target.effect_container != null:
		var mark = StatusEffect.new("malakor_focus_mark", StatusEffect.EffectType.DEBUFF, 4.0, 1.0, false)
		target.effect_container.apply_effect(mark)
		
	focus_fire_marked.emit(target)
	return true

# --- R: ROYAL VANGUARD (GROUND AOE SHOCKWAVE FORMATION) ---
func cast_malakor_r(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R, null, target_point):
		return false
		
	var hit_count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if target_point.distance_to(entity.global_position) <= 6.5:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Royal Vanguard")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.50, 3.0)
					hit_count += 1
					
	royal_vanguard_deployed.emit(target_point, hit_count)
	return true
