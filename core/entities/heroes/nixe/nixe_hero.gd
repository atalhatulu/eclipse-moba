class_name NixeHero
extends HeroEntity

## Implementation of Nixe

const DefScript = preload("res://data/heroes/nixe_definition.gd")

func _ready() -> void:
	entity_name = "Nixe"
	super._ready()
	_setup_collision()
	_create_visual_mesh()
	_apply_def()

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
	if not has_node("NixeVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "NixeVisual"
		add_child(root_vis)
		
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.52
		body_capsule.height = 2.0
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.0
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.35, 0.15, 0.40)
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)

func _apply_def() -> void:
	var def = DefScript.create_resource()
	_apply_hero_resource(def)
	hero_resource = def
	
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

# --- Q: POUNCE & AMBUSH ---

func cast_nixe_q(target_point: Vector3, targets: Array = []) -> DamageResult:
	var my_pos = global_position if is_inside_tree() else position
	var dir = (target_point - my_pos).normalized()
	if dir.length_squared() < 0.01:
		dir = Vector3(0, 0, -1)
		
	# Leap 7m forward
	var dest = my_pos + (dir * 7.0)
	dest.x = clampf(dest.x, -115.0, 115.0)
	dest.z = clampf(dest.z, -115.0, 115.0)
	if is_inside_tree():
		global_position = dest
	else:
		position = dest
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1) if ability_container != null else 1
	var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 85.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 56.0
	var total_dmg = base_dmg + (ad * 0.95)
	
	var enemies = targets.duplicate()
	if enemies.is_empty():
		if is_inside_tree() and get_tree() != null:
			enemies = get_tree().get_nodes_in_group("combat_entities")
		else:
			enemies.append_array(HeroEntity.active_heroes)
			enemies.append_array(CreepEntity.active_creeps)
			
	var primary_res: DamageResult = null
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and is_enemy_with(e) and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if dest.distance_to(e_pos) <= 3.5:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.PHYSICAL, "Pounce")
				var res = CombatCalculator.execute_damage(req)
				if primary_res == null:
					primary_res = res
				if e.effect_container != null:
					var stun_eff = StatusEffect.new("nixe_pounce_stun", StatusEffect.EffectType.STUN, 1.0, 0.0, true)
					stun_eff.source_entity = self
					e.effect_container.apply_effect(stun_eff)
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("NIXE: PUSU ATILIŞI! (Yere Çalma ve Sersemletme)")
	return primary_res

# --- W: ACID WEB ---

func cast_nixe_w(target_pos: Vector3) -> bool:
	if is_inside_tree():
		var web_script = load("res://scenes/effects/nixe_acid_web_3d.gd")
		if web_script != null:
			var web = web_script.new()
			get_tree().root.add_child(web)
			web.setup(target_pos, 4.5)
			
	var enemies: Array = []
	if is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		enemies.append_array(CreepEntity.active_creeps)
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1) if ability_container != null else 1
	var base_dmg = w_res.get_base_damage(lvl) if w_res != null else 70.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var total_dmg = base_dmg + (ap * 0.65)
	
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and is_enemy_with(e) and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if target_pos.distance_to(e_pos) <= 4.5:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Acid Web")
				CombatCalculator.execute_damage(req)
				if e.effect_container != null:
					var slow_eff = StatusEffect.new("nixe_web_slow", StatusEffect.EffectType.SLOW, 3.0, 0.50, true)
					slow_eff.source_entity = self
					e.effect_container.apply_effect(slow_eff)
				if e.attribute_system != null:
					e.attribute_system.remove_modifiers_by_source("nixe_acid_shred")
					var mod = StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.PERCENT_ADD, -0.25, "nixe_acid_shred", 4.0)
					e.attribute_system.add_modifier(mod)
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("NIXE: ASİTLİ ÖRÜMCEK AĞI SERİLDİ! (%%50 Yavaşlatma, %%25 Zırh Eritme)")
	return true

# --- E: SKITTER & EVASION ---

func cast_nixe_e() -> bool:
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("nixe_skitter_ms")
		var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.45, "nixe_skitter_ms", 2.0)
		attribute_system.add_modifier(mod)
		
	# Cleanse CC / debuffs
	if effect_container != null:
		effect_container.clear_all_debuffs()
		
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("NIXE: HIZLI TIRMANIŞ! (CC Silindi, +%%45 Hız)")
	return true

# --- R: TOXIC COCOON (ULTIMATE) ---

func cast_nixe_r(target: BaseCombatEntity) -> DamageResult:
	if target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or is_enemy_with(target) == false:
		return null
		
	var t_pos = target.global_position if target.is_inside_tree() else target.position
	
	# Spawn 3D Toxic Cocoon Mesh
	if is_inside_tree():
		var cocoon_script = load("res://scenes/effects/nixe_toxic_cocoon_3d.gd")
		if cocoon_script != null:
			var cocoon = cocoon_script.new()
			get_tree().root.add_child(cocoon)
			cocoon.setup(t_pos, 2.0)
			
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1) if ability_container != null else 1
	var base_dmg = r_res.get_base_damage(lvl) if r_res != null else 240.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 56.0
	var total_dmg = base_dmg + (ad * 1.25)
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Toxic Cocoon")
	var res = CombatCalculator.execute_damage(req)
	
	# 2.0s Complete Stun / Cocoon lock
	if target.effect_container != null:
		var stun_eff = StatusEffect.new("nixe_cocoon_stun", StatusEffect.EffectType.STUN, 2.0, 0.0, true)
		stun_eff.source_entity = self
		target.effect_container.apply_effect(stun_eff)
		
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("NIXE: ZEHİRLİ KOZA HAPSETTİ! (%s 2.0s Kilitlendi)" % target.entity_name)
	return res