class_name GromHero
extends HeroEntity

## Implementation of Grom - The Apex Stalker (STR Melee Hunter / Primal Assassin Bruiser)

signal scent_of_blood_triggered(target: BaseCombatEntity)
signal apex_hunt_activated()
signal apex_hunt_ended()

const DefScript = preload("res://data/heroes/grom_definition.gd")

var is_apex_hunt_active: bool = false
var apex_hunt_timer: float = 0.0
var grom_visual_root: Node3D = null

func _ready() -> void:
	entity_name = "Grom"
	hero_resource = DefScript.create_resource()
	super._ready()
	_setup_collision()
	_create_visual_mesh()

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
	if not has_node("GromVisual"):
		grom_visual_root = Node3D.new()
		grom_visual_root.name = "GromVisual"
		add_child(grom_visual_root)
		
		# Heavy Hunter Torso (2.1m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.55
		body_capsule.height = 2.1
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.05
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.22, 0.14, 0.12, 1.0) # Dark Primal Leather & Hide
		body_mat.metallic = 0.3
		body_mat.roughness = 0.8
		body_inst.material_override = body_mat
		grom_visual_root.add_child(body_inst)
		
		# Twin Bone Tusks / Shoulder Spikes
		for side in [-0.60, 0.60]:
			var tusk = MeshInstance3D.new()
			var t_cone = CylinderMesh.new()
			t_cone.top_radius = 0.02
			t_cone.bottom_radius = 0.15
			t_cone.height = 0.70
			tusk.mesh = t_cone
			tusk.position = Vector3(side, 1.70, -0.20)
			tusk.rotation_degrees = Vector3(-35, 0, side * 25.0)
			
			var t_mat = StandardMaterial3D.new()
			t_mat.albedo_color = Color(0.85, 0.80, 0.70, 1.0) # Bone Ivory
			t_mat.roughness = 0.5
			tusk.material_override = t_mat
			grom_visual_root.add_child(tusk)
			
		# Dual Primal Claws
		for side in [-0.55, 0.55]:
			var claw = MeshInstance3D.new()
			var c_box = BoxMesh.new()
			c_box.size = Vector3(0.12, 0.50, 0.25)
			claw.mesh = c_box
			claw.position = Vector3(side, 0.90, 0.45)
			claw.rotation_degrees = Vector3(25, 0, 0)
			
			var c_mat = StandardMaterial3D.new()
			c_mat.albedo_color = Color(0.60, 0.10, 0.10, 1.0)
			c_mat.emission_enabled = true
			c_mat.emission = Color(0.80, 0.15, 0.10)
			c_mat.emission_energy_multiplier = 1.2
			claw.material_override = c_mat
			grom_visual_root.add_child(claw)
			
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.85
		torus.outer_radius = 0.90
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		grom_visual_root.add_child(ring)
	else:
		grom_visual_root = get_node_or_null("GromVisual")

func _apply_def() -> void:
	var def = DefScript.create_resource()
	_apply_hero_resource(def)
	hero_resource = def

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_apex_hunt_active:
		apex_hunt_timer -= delta
		if apex_hunt_timer <= 0.0:
			_end_apex_hunt()
			
	_check_scent_of_blood()

func _check_scent_of_blood() -> void:
	if not is_alive():
		return
		
	var my_pos = global_position if is_inside_tree() else position
	var enemies: Array = []
	if is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		
	var found_wounded = false
	for e in enemies:
		if e is BaseCombatEntity and e != self and is_instance_valid(e) and e.is_alive() and is_enemy_with(e):
			if e.attribute_system != null:
				var max_h = maxf(1.0, e.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
				var cur_h = e.attribute_system.current_health
				if (cur_h / max_h) <= 0.40:
					var e_pos = e.global_position if e.is_inside_tree() else e.position
					if my_pos.distance_to(e_pos) <= 18.0:
						found_wounded = true
						scent_of_blood_triggered.emit(e)
						break
						
	if found_wounded:
		if attribute_system != null:
			attribute_system.remove_modifiers_by_source("grom_scent_ms")
			attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.30, "grom_scent_ms", 1.0))

# --- Q: SAVAGE REND ---

func cast_grom_q(target: BaseCombatEntity) -> DamageResult:
	if target == null or not is_instance_valid(target) or not target.is_alive() or not is_enemy_with(target):
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1) if ability_container != null else 1
	var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 85.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 56.0
	var total_dmg = base_dmg + (ad * 0.80)
	
	var t_pos = target.global_position if target.is_inside_tree() else target.position
	
	# Spawn Claw Slash VFX
	if is_inside_tree():
		var slash_script = load("res://scenes/effects/grom_claw_slash_3d.gd")
		if slash_script != null:
			var slash = slash_script.new()
			get_tree().root.add_child(slash)
			slash.global_position = t_pos
			
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Savage Rend")
	var res = CombatCalculator.execute_damage(req)
	
	# Apply 3s Bleed Status Effect
	if target.effect_container != null:
		var bleed = StatusEffect.new("grom_bleed", StatusEffect.EffectType.DAMAGE_OVER_TIME, 3.0, (ad * 0.30))
		bleed.source_entity = self
		target.effect_container.apply_effect(bleed)
		
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("GROM: VAHŞİ PENÇE VURDU (%d Hasar + Kanama)" % int(total_dmg))
	return res

# --- W: DREAD ROAR ---

func cast_grom_w() -> bool:
	var my_pos = global_position if is_inside_tree() else position
	
	# Spawn Dread Roar VFX
	if is_inside_tree():
		var roar_script = load("res://scenes/effects/grom_dread_roar_3d.gd")
		if roar_script != null:
			var roar = roar_script.new()
			get_tree().root.add_child(roar)
			roar.global_position = my_pos
			
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1) if ability_container != null else 1
	var base_dmg = w_res.get_base_damage(lvl) if w_res != null else 60.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 56.0
	var total_dmg = base_dmg + (ad * 0.50)
	
	var enemies: Array = []
	if is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		enemies.append_array(CreepEntity.active_creeps)
		
	for e in enemies:
		if e is BaseCombatEntity and e != self and is_instance_valid(e) and e.is_alive() and is_enemy_with(e):
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if my_pos.distance_to(e_pos) <= 4.5:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.PHYSICAL, "Dread Roar")
				CombatCalculator.execute_damage(req)
				if e.effect_container != null:
					var sil = StatusEffect.new("grom_silence", StatusEffect.EffectType.SILENCE, 1.5, 0.0)
					sil.source_entity = self
					e.effect_container.apply_effect(sil)
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("GROM: KORKUNÇ KÜKREME! (4.5m Alan Susturuldu)")
	return true

# --- E: PREDATORY POUNCE ---

func cast_grom_e(aim_pos: Vector3) -> bool:
	var my_pos = global_position if is_inside_tree() else position
	var dir = (aim_pos - my_pos)
	dir.y = 0.0
	if dir.length_squared() < 0.01:
		dir = Vector3(0, 0, -1.0)
	dir = dir.normalized()
	
	var dest = my_pos + (dir * 6.0)
	if is_inside_tree():
		global_position = dest
	else:
		position = dest
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1) if ability_container != null else 1
	var base_dmg = e_res.get_base_damage(lvl) if e_res != null else 75.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 56.0
	var total_dmg = base_dmg + (ad * 0.65)
	
	# Root first enemy collided
	var enemies: Array = []
	if is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		enemies.append_array(CreepEntity.active_creeps)
		
	for e in enemies:
		if e is BaseCombatEntity and e != self and is_instance_valid(e) and e.is_alive() and is_enemy_with(e):
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if dest.distance_to(e_pos) <= 2.5:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.PHYSICAL, "Predatory Pounce")
				CombatCalculator.execute_damage(req)
				if e.effect_container != null:
					var root_eff = StatusEffect.new("grom_root", StatusEffect.EffectType.ROOT, 1.2, 0.0)
					root_eff.source_entity = self
					e.effect_container.apply_effect(root_eff)
				break
				
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("GROM: AV ATILIŞI! (Hedef Sabitlendi)")
	return true

# --- R: APEX HUNT (ULTIMATE) ---

func cast_grom_r(target: BaseCombatEntity = null) -> bool:
	is_apex_hunt_active = true
	apex_hunt_timer = 10.0
	
	# Attach Apex Hunt Aura VFX
	if is_inside_tree():
		var aura_script = load("res://scenes/effects/grom_apex_hunt_aura_3d.gd")
		if aura_script != null:
			var aura = aura_script.new()
			add_child(aura)
			aura.position = Vector3.ZERO
			
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("grom_hunt_ms")
		attribute_system.remove_modifiers_by_source("grom_hunt_as")
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.50, "grom_hunt_ms", 10.0))
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, 0.40, "grom_hunt_as", 10.0))
		
	if target != null and is_instance_valid(target) and target.is_alive() and is_enemy_with(target):
		var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null) if ability_container != null else null
		var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1) if ability_container != null else 1
		var base_dmg = r_res.get_base_damage(lvl) if r_res != null else 200.0
		var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 56.0
		var total_dmg = base_dmg + (ad * 1.0)
		
		# Leap onto target and pin/disarm
		if is_inside_tree() and target.is_inside_tree():
			global_position = target.global_position - (target.global_position - global_position).normalized() * 1.2
			
		var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Apex Hunt")
		CombatCalculator.execute_damage(req)
		
		if target.effect_container != null:
			var disarm = StatusEffect.new("grom_mutilate", StatusEffect.EffectType.DISARM, 1.8, 0.0)
			disarm.source_entity = self
			target.effect_container.apply_effect(disarm)
			
	apex_hunt_activated.emit()
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("GROM: VAHŞİ AV (APEX HUNT) BAŞLADI! (+%50 Hız, +%40 Saldırı Hızı)")
	return true

func _end_apex_hunt() -> void:
	is_apex_hunt_active = false
	apex_hunt_timer = 0.0
	apex_hunt_ended.emit()

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	_end_apex_hunt()

func respawn() -> void:
	super.respawn()
	_end_apex_hunt()
