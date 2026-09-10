class_name AriaHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Implementation of Aria (The Flawless Duelist / AGI Noble Fencer)
## Excels in 1v1 duels with Lunge dashes, Riposte parry immunity, Disarm, and multi-strike Dance of Death.

signal lunge_executed(start_pos: Vector3, end_pos: Vector3, enemies_hit: int)
signal riposte_stance_started()
signal riposte_counter_struck(enemies_hit: int)
signal disarm_struck(target: BaseCombatEntity)
signal dance_of_death_completed(target: BaseCombatEntity, total_damage: float)

var aria_visual_root: Node3D = null
var rapier_blade: MeshInstance3D = null
var duelist_hat: MeshInstance3D = null

# W: Riposte State
var is_riposting: bool = false
var riposte_timer: float = 0.0
const RIPOSTE_DURATION: float = 1.0

func _ready() -> void:
	entity_name = "Aria"
	hero_resource = AriaDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_aria_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.50
		shape.height = 2.0
		col.shape = shape
		col.position.y = 1.0
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("AriaVisual"):
		aria_visual_root = Node3D.new()
		aria_visual_root.name = "AriaVisual"
		add_child(aria_visual_root)
		
		# Duelist Body (Slender Crimson/Gold Vest)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.44
		body_capsule.height = 1.95
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.98
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.85, 0.16, 0.38, 1.0) # Noble Crimson Velvet
		mat.metallic = 0.35
		mat.roughness = 0.30
		body_inst.material_override = mat
		aria_visual_root.add_child(body_inst)
		
		# Duelist Feather / Crest
		duelist_hat = MeshInstance3D.new()
		var plume = CylinderMesh.new()
		plume.top_radius = 0.05
		plume.bottom_radius = 0.28
		plume.height = 0.45
		duelist_hat.mesh = plume
		duelist_hat.position = Vector3(0.0, 2.0, -0.1)
		var plume_mat = StandardMaterial3D.new()
		plume_mat.albedo_color = Color(0.95, 0.85, 0.3, 1.0) # Gold Plume
		duelist_hat.material_override = plume_mat
		aria_visual_root.add_child(duelist_hat)
		
		# Luminous Rapier Sword
		rapier_blade = MeshInstance3D.new()
		var blade_mesh = CylinderMesh.new()
		blade_mesh.top_radius = 0.02
		blade_mesh.bottom_radius = 0.06
		blade_mesh.height = 1.4
		rapier_blade.mesh = blade_mesh
		rapier_blade.position = Vector3(0.55, 0.85, 0.45)
		rapier_blade.rotation_degrees = Vector3(-65, 25, 0)
		
		var blade_mat = StandardMaterial3D.new()
		blade_mat.albedo_color = Color(0.9, 0.95, 1.0, 1.0)
		blade_mat.metallic = 0.95
		blade_mat.roughness = 0.15
		blade_mat.emission_enabled = true
		blade_mat.emission = Color(0.8, 0.9, 1.0)
		blade_mat.emission_energy_multiplier = 1.5
		rapier_blade.material_override = blade_mat
		aria_visual_root.add_child(rapier_blade)
	else:
		aria_visual_root = get_node_or_null("AriaVisual")

func _apply_aria_definition() -> void:
	if hero_resource == null:
		hero_resource = AriaDefinition.create_resource()
		
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
	_process_riposte(delta)

func _process_riposte(delta: float) -> void:
	if not is_riposting:
		return
	riposte_timer -= delta
	if riposte_timer <= 0.0:
		_end_riposte_and_counter()

# --- Q: LUNGE (POINT / DIRECTIONAL DASH) ---
func cast_aria_q(target_point: Vector3) -> bool:
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
		
	var dash_dist = minf(7.0, cur_pos.distance_to(target_point))
	if dash_dist < 1.0:
		dash_dist = 6.0
	var destination = cur_pos + dir * dash_dist
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, null, target_point):
		return false
		
	# Dash displacement
	if is_inside_tree():
		global_position = destination
	else:
		position = destination
		
	# Hit enemies along trajectory
	var hit_count := 0
	var hero_hit := false
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				var dist_to_line = (entity.global_position - cur_pos).cross(dir).length()
				var dot = (entity.global_position - cur_pos).dot(dir)
				if dot >= 0.0 and dot <= dash_dist and dist_to_line <= 1.8:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Lunge")
					CombatCalculator.execute_damage(req)
					hit_count += 1
					if entity is HeroEntity:
						hero_hit = true
						
	# Cooldown refund mechanic on champion strike
	if hero_hit:
		var current_cd = ability_container.cooldown_timers.get(AbilityResource.Slot.Q, 0.0)
		ability_container.cooldown_timers[AbilityResource.Slot.Q] = current_cd * 0.5
		
	_play_thrust_animation(dir)
	lunge_executed.emit(cur_pos, destination, hit_count)
	return true

# --- W: RIPOSTE (SELF PARRY STANCE + COUNTER-SLASH) ---
func cast_aria_w() -> bool:
	if not can_cast():
		return false
	if not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	is_riposting = true
	riposte_timer = RIPOSTE_DURATION
	
	# Apply invulnerability / parry buff
	if effect_container != null:
		effect_container.apply_spell_immunity(RIPOSTE_DURATION)
		CombatMechanicsClass.apply_shield(self, self, "aria_riposte_parry", "Hamle Savuşturma", 9999.0, RIPOSTE_DURATION)
		
	if aria_visual_root != null and is_inside_tree():
		var tw = create_tween()
		if tw != null:
			tw.tween_property(aria_visual_root, "scale", Vector3(1.15, 1.15, 1.15), 0.15)
			
	riposte_stance_started.emit()
	return true

func _end_riposte_and_counter() -> void:
	is_riposting = false
	if aria_visual_root != null and is_inside_tree():
		aria_visual_root.scale = Vector3.ONE
		
	# Counter-slash in 180-degree front arc
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl) if w_res != null else 120.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * 0.70)
	
	var cur_pos = global_position if is_inside_tree() else position
	var facing = -transform.basis.z.normalized()
	var hit_count := 0
	
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				var diff = entity.global_position - cur_pos
				diff.y = 0.0
				if diff.length() <= 4.5:
					var dot = facing.dot(diff.normalized())
					if dot > 0.0: # In front arc
						var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Riposte Counter")
						CombatCalculator.execute_damage(req)
						if "effect_container" in entity and entity.effect_container != null:
							entity.effect_container.apply_slow(0.50, 2.0)
						hit_count += 1
						
	riposte_counter_struck.emit(hit_count)

# --- E: DISARM (SINGLE TARGET WEAPON STRIKE) ---
func cast_aria_e(target: BaseCombatEntity) -> bool:
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
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Disarm")
	CombatCalculator.execute_damage(req)
	
	# Apply disarm / silence effect
	if "effect_container" in target and target.effect_container != null:
		target.effect_container.apply_silence(2.2)
		target.effect_container.apply_slow(0.30, 2.2)
		
	_play_thrust_animation((target.global_position - global_position).normalized() if is_inside_tree() else Vector3.FORWARD)
	disarm_struck.emit(target)
	return true

# --- R: DANCE OF DEATH (SINGLE TARGET MULTI-STRIKE FLURRY) ---
func cast_aria_r(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return false
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R, target):
		return false
		
	# Execute 4 rapid strikes dealing total damage and healing Aria for 35% of damage dealt
	var strike_damage = total_dmg / 4.0
	for i in range(4):
		if target.is_alive():
			var req = DamageRequest.create_ability_damage(self, target, strike_damage, DamageRequest.DamageType.PHYSICAL, "Dance of Death")
			var res = CombatCalculator.execute_damage(req)
			if res != null and res.final_health_damage > 0.0:
				attribute_system.heal(res.final_health_damage * 0.35)
				
	# Reposition to back of target
	if is_inside_tree() and target.is_alive():
		var back_pos = target.global_position + target.transform.basis.z.normalized() * 1.5
		global_position = back_pos
		
	dance_of_death_completed.emit(target, total_dmg)
	return true

func _play_thrust_animation(dir: Vector3) -> void:
	if rapier_blade == null or not is_inside_tree():
		return
	var tw = create_tween()
	if tw != null:
		tw.tween_property(rapier_blade, "position:z", 1.2, 0.08)
		tw.tween_property(rapier_blade, "position:z", 0.45, 0.12)
