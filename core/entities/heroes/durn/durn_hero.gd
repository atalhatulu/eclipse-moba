class_name DurnHero
extends HeroEntity

## Implementation of Durn (The Iron Colossus / STR Siege Artillery)

signal siege_stance_changed(is_active: bool)
signal fortify_activated()
signal fortify_ended()
signal mine_placed(location: Vector3)
signal mine_detonated(location: Vector3)
signal grand_barrage_fired(location: Vector3)

# Siege Stance State
var is_siege_stance: bool = false
var standstill_timer: float = 0.0
var last_pos: Vector3 = Vector3.ZERO

# Fortify State
var is_fortified: bool = false
var fortify_timer: float = 0.0

# Shock Mines State
var active_mines: Array[Dictionary] = []

func _ready() -> void:
	entity_name = "Durn"
	hero_resource = DurnDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_durn_definition()
	last_pos = global_position if is_inside_tree() else position

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.70
		shape.height = 2.2
		col.shape = shape
		col.position.y = 1.10
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("DurnVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "DurnVisual"
		add_child(root_vis)
		
		# Heavy Fortified Iron Hull (2.2m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.65
		body_capsule.height = 2.2
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.10
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.32, 0.28, 0.25, 1.0) # Siege Iron / Granite
		body_mat.metallic = 0.85
		body_mat.roughness = 0.45
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Rear Mortar / Cannon Mesh
		var cannon = MeshInstance3D.new()
		var cyl = CylinderMesh.new()
		cyl.top_radius = 0.20
		cyl.bottom_radius = 0.25
		cyl.height = 1.2
		cannon.mesh = cyl
		cannon.position = Vector3(0.0, 1.7, -0.4)
		cannon.rotation_degrees = Vector3(-35, 0, 0)
		
		var can_mat = StandardMaterial3D.new()
		can_mat.albedo_color = Color(0.20, 0.20, 0.22, 1.0)
		can_mat.metallic = 0.90
		cannon.material_override = can_mat
		root_vis.add_child(cannon)
		
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.95
		torus.outer_radius = 1.00
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_durn_definition() -> void:
	if hero_resource == null:
		hero_resource = DurnDefinition.create_resource()
		
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
	
	attribute_system.recalculate_all_stats()
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
	attribute_system.restore_mana(attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA))
	
	# Assign abilities
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

func _process(delta: float) -> void:
	super._process(delta)
	_process_siege_stance(delta)

# --- PASSIVE: IRON HULL ---

func _process_siege_stance(_delta: float) -> void:
	if not is_alive():
		return
	# Iron Hull gives 30% bonus armor when stationary or in siege mode
	if attribute_system != null:
		var is_standing = (velocity.length_squared() < 0.1 or is_siege_stance)
		attribute_system.remove_modifiers_by_source("durn_iron_hull")
		if is_standing:
			attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.PERCENT_ADD, 0.30, "durn_iron_hull"))

# --- Q: MORTAR SHELL ---

func cast_durn_q(target_point: Vector3, targets: Array = []) -> DamageResult:
	# Spawn 3D Mortar Crater Explosion
	if is_inside_tree():
		var mortar_script = load("res://scenes/effects/durn_mortar_impact_3d.gd")
		if mortar_script != null:
			var imp = mortar_script.new()
			get_tree().root.add_child(imp)
			imp.global_position = target_point
			
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1) if ability_container != null else 1
	var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 90.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 52.0
	var total_dmg = base_dmg + (ad * 0.85)
	
	if is_siege_stance:
		total_dmg *= 1.25 # +25% Mortar damage in Siege Mode
		
	var enemies: Array = targets.duplicate()
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
			var dist = target_point.distance_to(e_pos)
			if dist <= 4.0:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.PHYSICAL, "Mortar Shell")
				var res = CombatCalculator.execute_damage(req)
				if primary_res == null:
					primary_res = res
				# Center epicenter stun (0.8s)
				if dist <= 2.0 and e.effect_container != null:
					var stun_eff = StatusEffect.new("durn_mortar_stun", StatusEffect.EffectType.STUN, 0.8, 0.0)
					stun_eff.source_entity = self
					e.effect_container.apply_effect(stun_eff)
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("DURN: HAVAN MERMİSİ PATLADI! (Krater Şoku)")
	return primary_res

# --- W: DEPLOY SIEGE TANK MODE ---

func cast_durn_w() -> bool:
	if not is_siege_stance:
		# ENTER SIEGE MODE
		is_siege_stance = true
		
		# Spawn 3D Ground Anchors and Range Ring
		if is_inside_tree():
			var deploy_script = load("res://scenes/effects/durn_siege_deploy_3d.gd")
			if deploy_script != null:
				var deploy_vfx = deploy_script.new()
				add_child(deploy_vfx)
				deploy_vfx.position = Vector3.ZERO
				
		if attribute_system != null:
			attribute_system.remove_modifiers_by_source("durn_siege_lock")
			attribute_system.remove_modifiers_by_source("durn_siege_range")
			attribute_system.remove_modifiers_by_source("durn_siege_def")
			
			# Lock Movement to 0, Triple Attack Range (1600m), +50 Armor & MR
			attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, -1.0, "durn_siege_lock"))
			attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_RANGE, StatModifier.Type.FLAT, 1100.0, "durn_siege_range"))
			attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, 50.0, "durn_siege_def"))
			attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MAGIC_RESIST, StatModifier.Type.FLAT, 50.0, "durn_siege_def"))
			
		siege_stance_changed.emit(true)
		if Engine.has_singleton("GameEvents"):
			Engine.get_singleton("GameEvents").combat_log_generated.emit("DURN: KUŞATMA MODUNA GEÇTİ! (Menzil 1600m, +50 Zırh, Sabitlendi)")
	else:
		# EXIT SIEGE MODE
		is_siege_stance = false
		if attribute_system != null:
			attribute_system.remove_modifiers_by_source("durn_siege_lock")
			attribute_system.remove_modifiers_by_source("durn_siege_range")
			attribute_system.remove_modifiers_by_source("durn_siege_def")
			
		# Remove anchor VFX
		for c in get_children():
			if c.has_method("_create_anchors"):
				c.queue_free()
				
		siege_stance_changed.emit(false)
		if Engine.has_singleton("GameEvents"):
			Engine.get_singleton("GameEvents").combat_log_generated.emit("DURN: KUŞATMA MODUNDAN ÇIKTI (Mobil Form)")
	return true

# --- E: CONCUSSION BLAST ---

func cast_durn_e(aim_pos: Vector3) -> bool:
	var my_pos = global_position if is_inside_tree() else position
	var dir = (aim_pos - my_pos).normalized()
	if dir.length_squared() < 0.01:
		dir = Vector3(0, 0, -1)
		
	# Spawn 3D Concussion Blast Ring
	if is_inside_tree():
		var blast_script = load("res://scenes/effects/durn_concussion_blast_3d.gd")
		if blast_script != null:
			var blast = blast_script.new()
			get_tree().root.add_child(blast)
			blast.global_position = my_pos
			
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1) if ability_container != null else 1
	var base_dmg = e_res.get_base_damage(lvl) if e_res != null else 80.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 52.0
	var total_dmg = base_dmg + (ad * 0.70)
	
	# Push Durn backwards 2m (if not deployed in siege mode)
	if not is_siege_stance:
		var push_dest = my_pos - (dir * 2.0)
		push_dest.x = clampf(push_dest.x, -115.0, 115.0)
		push_dest.z = clampf(push_dest.z, -115.0, 115.0)
		if is_inside_tree():
			global_position = push_dest
		else:
			position = push_dest
			
	# Knock nearby enemies away by 5m
	var enemies: Array = []
	if is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		enemies.append_array(CreepEntity.active_creeps)
		
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and is_enemy_with(e) and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if my_pos.distance_to(e_pos) <= 4.5:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.PHYSICAL, "Concussion Blast")
				CombatCalculator.execute_damage(req)
				
				# Push enemy back 5m
				var knock_dir = (e_pos - my_pos).normalized()
				var knock_dest = e_pos + (knock_dir * 5.0)
				knock_dest.x = clampf(knock_dest.x, -115.0, 115.0)
				knock_dest.z = clampf(knock_dest.z, -115.0, 115.0)
				if e.is_inside_tree():
					e.global_position = knock_dest
				else:
					e.position = knock_dest
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("DURN: GERİ TEPME ŞOKU! (Düşmanlar 5m Savruldu)")
	return true

# --- R: ORBITAL SIEGE DEVASTATION (ULTIMATE) ---

func cast_durn_r(target_location: Vector3, nearby_targets: Array = []) -> Array[DamageResult]:
	# Spawn 3D Orbital Seismic Barrage VFX
	if is_inside_tree():
		var orb_script = load("res://scenes/effects/durn_orbital_barrage_3d.gd")
		if orb_script != null:
			var orb = orb_script.new()
			get_tree().root.add_child(orb)
			orb.setup(target_location)
			
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1) if ability_container != null else 1
	var base_dmg = r_res.get_base_damage(lvl) if r_res != null else 250.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 52.0
	var total_dmg = base_dmg + (ad * 1.25)
	
	var targets_to_hit = nearby_targets.duplicate()
	if targets_to_hit.is_empty():
		var all_nodes: Array = []
		if is_inside_tree() and get_tree() != null:
			all_nodes = get_tree().get_nodes_in_group("combat_entities")
		else:
			all_nodes.append_array(HeroEntity.active_heroes)
			all_nodes.append_array(CreepEntity.active_creeps)
			
		for n in all_nodes:
			if n is BaseCombatEntity and is_instance_valid(n) and n != self and n.is_alive() and is_enemy_with(n) and n.is_targetable:
				var n_pos = n.global_position if is_inside_tree() else n.position
				if target_location.distance_to(n_pos) <= 6.5:
					targets_to_hit.append(n)
					
	var results: Array[DamageResult] = []
	for t in targets_to_hit:
		var req = DamageRequest.create_ability_damage(self, t, total_dmg, DamageRequest.DamageType.PHYSICAL, "Orbital Devastation")
		var res = CombatCalculator.execute_damage(req)
		results.append(res)
		
		# Shred 35% armor for 5.0s
		if t.attribute_system != null:
			t.attribute_system.remove_modifiers_by_source("durn_orbital_shred")
			var mod = StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.PERCENT_ADD, -0.35, "durn_orbital_shred", 5.0)
			t.attribute_system.add_modifier(mod)
			
	grand_barrage_fired.emit(target_location)
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("DURN: YÖRÜNGESEL KUŞATMA BOMBARDIMANI YAĞDI! (%d Düşman Vuruldu, %%35 Zırh Parçalandı)" % results.size())
	return results

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	is_siege_stance = false
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("durn_siege_lock")
		attribute_system.remove_modifiers_by_source("durn_siege_range")
		attribute_system.remove_modifiers_by_source("durn_siege_def")

func respawn() -> void:
	super.respawn()
	is_siege_stance = false
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("durn_siege_lock")
		attribute_system.remove_modifiers_by_source("durn_siege_range")
		attribute_system.remove_modifiers_by_source("durn_siege_def")
