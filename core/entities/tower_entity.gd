class_name TowerEntity
extends BaseCombatEntity

## Defensive lane structure providing true sight, heavy projectile fire, dynamic aggro switching, and backdoor protection

@export var tier: int = 1
@export var team_bounty_gold: int = 150
@export var aggro_range: float = 12.0 # 12.0 meters in 3D world space
@export var backdoor_protection_enabled: bool = true
@export var has_true_sight: bool = true

var attack_cooldown_timer: float = 0.0
var aggro_switch_cooldown: float = 0.0
var is_destroyed: bool = false
var range_indicator: MeshInstance3D = null
var targeting_laser: MeshInstance3D = null
var _laser_material: StandardMaterial3D = null

# Backdoor Protection State
var backdoor_protection_radius: float = 18.0
var is_backdoor_active: bool = true
var backdoor_disable_timer: float = 0.0
var backdoor_hp_baseline: float = 0.0
var backdoor_regen_rate: float = 90.0 # 90 HP per second

# Active Tower Registry
static var active_towers: Array[TowerEntity] = []

func _init() -> void:
	active_towers.append(self)

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		active_towers.erase(self)

func set_range_indicator_visible(p_visible: bool) -> void:
	if range_indicator == null:
		range_indicator = find_child("RangeIndicator", true, false) as MeshInstance3D
	if range_indicator != null:
		range_indicator.visible = p_visible

func _ready() -> void:
	super._ready()
	_apply_tower_stats()
	_create_visual_mesh()
	_setup_range_indicator()
	_setup_targeting_laser()
	
	backdoor_hp_baseline = attribute_system.current_health
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		if not GameEvents.attack_started.is_connected(_on_global_attack_started):
			GameEvents.attack_started.connect(_on_global_attack_started)

func _setup_range_indicator() -> void:
	if range_indicator == null:
		range_indicator = find_child("RangeIndicator", true, false) as MeshInstance3D
	if range_indicator != null:
		range_indicator.visible = false

func _setup_targeting_laser() -> void:
	if not has_node("TargetingLaser"):
		targeting_laser = MeshInstance3D.new()
		targeting_laser.name = "TargetingLaser"
		var cyl = CylinderMesh.new()
		cyl.top_radius = 0.05
		cyl.bottom_radius = 0.05
		cyl.height = 1.0
		cyl.radial_segments = 8
		targeting_laser.mesh = cyl
		
		_laser_material = StandardMaterial3D.new()
		_laser_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		_laser_material.albedo_color = Color(1.0, 0.15, 0.15, 0.85)
		_laser_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		_laser_material.emission_enabled = true
		_laser_material.emission = Color(1.0, 0.15, 0.15)
		_laser_material.emission_energy_multiplier = 4.0
		targeting_laser.material_override = _laser_material
		targeting_laser.visible = false
		add_child(targeting_laser)

func _apply_tower_stats() -> void:
	attribute_system.base_strength = 0.0
	attribute_system.base_agility = 0.0
	attribute_system.base_intelligence = 0.0
	
	attribute_system.base_health = 2500.0 + (float(tier - 1) * 1000.0)
	attribute_system.base_attack_damage = 120.0 + (float(tier - 1) * 40.0)
	attribute_system.base_armor = 18.0 + (float(tier - 1) * 6.0)
	attribute_system.base_magic_resist = 25.0
	attribute_system.base_attack_range = aggro_range * 100.0
	attribute_system.base_attack_speed = 0.85
	attribute_system.base_move_speed = 0.0 # Immobile
	
	attribute_system.recalculate_all_stats()
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
	backdoor_hp_baseline = attribute_system.current_health

func _create_visual_mesh() -> void:
	if not has_node("TowerVisual"):
		var root_visual = Node3D.new()
		root_visual.name = "TowerVisual"
		add_child(root_visual)
		
		# 1. Base Pedestal (0.8m)
		var pedestal = MeshInstance3D.new()
		var base_cyl = CylinderMesh.new()
		base_cyl.top_radius = 1.4
		base_cyl.bottom_radius = 1.7
		base_cyl.height = 0.8
		pedestal.mesh = base_cyl
		pedestal.position.y = 0.4
		var stone_mat = StandardMaterial3D.new()
		stone_mat.albedo_color = Color(0.22, 0.24, 0.26, 1.0)
		pedestal.material_override = stone_mat
		root_visual.add_child(pedestal)
		
		# 2. Main Pillar (3.6m -> Top reaches 4.4m)
		var pillar = MeshInstance3D.new()
		var cyl = CylinderMesh.new()
		cyl.top_radius = 0.85
		cyl.bottom_radius = 1.2
		cyl.height = 3.6
		pillar.mesh = cyl
		pillar.position.y = 0.8 + 1.8 # 2.6m
		
		var team_mat = StandardMaterial3D.new()
		if team == TeamDefinitions.Team.RADIANT:
			team_mat.albedo_color = Color(0.18, 0.45, 0.25, 1.0)
			team_mat.metallic = 0.3
		else:
			team_mat.albedo_color = Color(0.48, 0.18, 0.18, 1.0)
			team_mat.metallic = 0.3
		pillar.material_override = team_mat
		root_visual.add_child(pillar)
		
		# 3. Glowing Energy Crystal on Top (Reaches 5.0m)
		var crystal = MeshInstance3D.new()
		var prism = SphereMesh.new()
		prism.radius = 0.50
		prism.height = 1.0
		crystal.mesh = prism
		crystal.position.y = 0.8 + 3.6 + 0.5 # 4.9m
		
		var crystal_mat = StandardMaterial3D.new()
		if team == TeamDefinitions.Team.RADIANT:
			crystal_mat.albedo_color = Color(0.2, 0.95, 0.4, 1.0)
			crystal_mat.emission_enabled = true
			crystal_mat.emission = Color(0.1, 0.85, 0.3, 1.0)
			crystal_mat.emission_energy_multiplier = 2.0
		else:
			crystal_mat.albedo_color = Color(0.95, 0.2, 0.2, 1.0)
			crystal_mat.emission_enabled = true
			crystal_mat.emission = Color(0.85, 0.1, 0.1, 1.0)
			crystal_mat.emission_energy_multiplier = 2.0
		crystal.material_override = crystal_mat
		root_visual.add_child(crystal)
		
		# 4. Effective Attack Range Indicator Ring on Ground (12.0m Radius)
		var range_ring = MeshInstance3D.new()
		range_ring.name = "RangeIndicator"
		var torus = TorusMesh.new()
		torus.inner_radius = aggro_range - 0.12
		torus.outer_radius = aggro_range + 0.12
		torus.rings = 64
		torus.ring_segments = 32
		range_ring.mesh = torus
		range_ring.position.y = 0.05 # Slightly above floor
		range_ring.visible = false
		range_indicator = range_ring
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var r_color = Color(0.2, 0.95, 0.4, 0.40) if team == TeamDefinitions.Team.RADIANT else Color(0.95, 0.2, 0.2, 0.40)
		ring_mat.albedo_color = r_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		range_ring.material_override = ring_mat
		root_visual.add_child(range_ring)
		
	if not has_node("TowerCollision"):
		var col = CollisionShape3D.new()
		col.name = "TowerCollision"
		var cyl_shape = CylinderShape3D.new()
		cyl_shape.radius = 1.4
		cyl_shape.height = 5.0
		col.shape = cyl_shape
		col.position.y = 2.5
		add_child(col)

func get_crystal_launch_position() -> Vector3:
	var self_pos = global_position if is_inside_tree() else position
	return self_pos + Vector3(0.0, 4.9, 0.0)

func _physics_process(delta: float) -> void:
	if not is_alive() or is_destroyed:
		return
		
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer -= delta
	if aggro_switch_cooldown > 0.0:
		aggro_switch_cooldown -= delta
		
	_process_backdoor_protection(delta)
	_process_true_sight()
	_update_target()
	_update_targeting_laser(delta)
	
	if current_target != null and attack_cooldown_timer <= 0.0:
		_execute_tower_attack(current_target)

func _update_targeting_laser(_delta: float) -> void:
	if targeting_laser == null:
		return
	# Show warning laser when targeting an Enemy Hero!
	if current_target != null and is_instance_valid(current_target) and current_target is HeroEntity and is_alive() and not is_destroyed and is_inside_tree():
		targeting_laser.visible = true
		var start_pt = get_crystal_launch_position()
		var end_pt = current_target.global_position + Vector3(0, 1.2, 0)
		var dir = end_pt - start_pt
		var dist = dir.length()
		
		if dist > 0.1:
			var mid_pt = start_pt + (dir * 0.5)
			targeting_laser.global_position = mid_pt
			targeting_laser.scale = Vector3(1.0, dist, 1.0)
			
			var up_vec = Vector3.UP if absf(dir.normalized().dot(Vector3.UP)) < 0.99 else Vector3.FORWARD
			targeting_laser.look_at(end_pt, up_vec)
			targeting_laser.rotate_object_local(Vector3.RIGHT, PI / 2.0)
			
		if _laser_material != null:
			var pulse = 0.65 + (sin(Time.get_ticks_msec() * 0.015) * 0.35)
			_laser_material.albedo_color.a = pulse
	else:
		targeting_laser.visible = false

func _on_global_attack_started(attacker: Node, victim: Node) -> void:
	if not is_alive() or is_destroyed:
		return
	if attacker is HeroEntity and victim is HeroEntity:
		var att_hero = attacker as HeroEntity
		var vic_hero = victim as HeroEntity
		if att_hero.team != team and vic_hero.team == team:
			var self_pos = global_position if is_inside_tree() else position
			var att_pos = att_hero.global_position if att_hero.is_inside_tree() else att_hero.position
			var vic_pos = vic_hero.global_position if vic_hero.is_inside_tree() else vic_hero.position
			
			# If enemy hero attacks friendly hero within tower aggro radius
			if self_pos.distance_to(att_pos) <= aggro_range and self_pos.distance_to(vic_pos) <= aggro_range:
				current_target = att_hero
				aggro_switch_cooldown = 2.5
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.tower_retaliated_aggro.emit(self, att_hero, vic_hero)
					GameEvents.combat_log_generated.emit("KULE KORUMASI: %s kulesi dost kahramana saldıran %s hedefine kilitlendi!" % [entity_name, att_hero.entity_name])

func _process_backdoor_protection(delta: float) -> void:
	if not backdoor_protection_enabled or not is_alive() or is_destroyed:
		return
		
	var self_pos = global_position if is_inside_tree() else position
	var enemy_creep_found = false
	
	for c in CreepEntity.active_creeps:
		if is_instance_valid(c) and c.is_alive() and c.team != team and c.team != TeamDefinitions.Team.NEUTRAL:
			var c_pos = c.global_position if c.is_inside_tree() else c.position
			if self_pos.distance_to(c_pos) <= backdoor_protection_radius:
				enemy_creep_found = true
				break
				
	if enemy_creep_found:
		is_backdoor_active = false
		backdoor_disable_timer = 15.0 # Stay disabled for 15s after creep death/exit
		backdoor_hp_baseline = attribute_system.current_health
	else:
		if backdoor_disable_timer > 0.0:
			backdoor_disable_timer -= delta
			is_backdoor_active = false
		else:
			is_backdoor_active = true
			
	# Fast HP Regen when backdoor protection is active and HP is below baseline
	if is_backdoor_active and attribute_system != null:
		var cur_hp = attribute_system.current_health
		if cur_hp < backdoor_hp_baseline:
			var new_hp = minf(cur_hp + (backdoor_regen_rate * delta), backdoor_hp_baseline)
			attribute_system.heal(new_hp - cur_hp)
		else:
			backdoor_hp_baseline = cur_hp

func _process_true_sight() -> void:
	if not has_true_sight or not is_alive() or is_destroyed:
		return
	var self_pos = global_position if is_inside_tree() else position
	for h in HeroEntity.active_heroes:
		if is_instance_valid(h) and h.is_alive() and h.team != team:
			var h_pos = h.global_position if h.is_inside_tree() else h.position
			if self_pos.distance_to(h_pos) <= aggro_range:
				if "is_revealed" in h:
					h.is_revealed = true

func _update_target() -> void:
	var self_pos = global_position if is_inside_tree() else position
	# Check if current target is still valid and in range
	if current_target != null:
		var t_pos = current_target.global_position if current_target.is_inside_tree() else current_target.position
		if not is_instance_valid(current_target) or not current_target.is_alive() or self_pos.distance_to(t_pos) > aggro_range:
			current_target = null
			
	if current_target == null:
		current_target = _find_highest_priority_target()

func _find_highest_priority_target() -> BaseCombatEntity:
	var self_pos = global_position if is_inside_tree() else position
	
	# Collect all possible living enemies within aggro range
	var nearby_enemies: Array[BaseCombatEntity] = []
	
	for h in HeroEntity.active_heroes:
		if is_instance_valid(h) and h.is_alive() and h.team != team and h.team != TeamDefinitions.Team.NEUTRAL:
			var h_pos = h.global_position if h.is_inside_tree() else h.position
			if self_pos.distance_to(h_pos) <= aggro_range:
				nearby_enemies.append(h)
				
	for c in CreepEntity.active_creeps:
		if is_instance_valid(c) and c.is_alive() and c.team != team and c.team != TeamDefinitions.Team.NEUTRAL:
			var c_pos = c.global_position if c.is_inside_tree() else c.position
			if self_pos.distance_to(c_pos) <= aggro_range:
				nearby_enemies.append(c)
				
	if get_tree() != null:
		var nodes = get_tree().get_nodes_in_group("combat_entities")
		for n in nodes:
			if n is BaseCombatEntity and n != self and n.is_alive() and n.team != team and n.team != TeamDefinitions.Team.NEUTRAL:
				if not (n in nearby_enemies):
					var n_pos = n.global_position if n.is_inside_tree() else n.position
					if self_pos.distance_to(n_pos) <= aggro_range:
						nearby_enemies.append(n)
						
	if nearby_enemies.is_empty():
		return null
		
	# Priority 1: Enemy unit actively attacking this tower
	var direct_attackers: Array[BaseCombatEntity] = []
	for e in nearby_enemies:
		if e.current_target == self:
			direct_attackers.append(e)
	if not direct_attackers.is_empty():
		return _get_closest_unit(direct_attackers, self_pos)
		
	# Priority 2: Closest enemy creep
	var creeps: Array[BaseCombatEntity] = []
	for e in nearby_enemies:
		if e is CreepEntity:
			creeps.append(e)
	if not creeps.is_empty():
		return _get_closest_unit(creeps, self_pos)
		
	# Priority 3: Closest enemy hero
	var heroes: Array[BaseCombatEntity] = []
	for e in nearby_enemies:
		if e is HeroEntity:
			heroes.append(e)
	if not heroes.is_empty():
		return _get_closest_unit(heroes, self_pos)
		
	# Priority 4: Closest other unit
	return _get_closest_unit(nearby_enemies, self_pos)

func _get_closest_unit(units: Array[BaseCombatEntity], from_pos: Vector3) -> BaseCombatEntity:
	var closest: BaseCombatEntity = null
	var min_dist: float = 99999.0
	for u in units:
		var u_pos = u.global_position if u.is_inside_tree() else u.position
		var d = from_pos.distance_to(u_pos)
		if d < min_dist:
			min_dist = d
			closest = u
	return closest

func drop_aggro(source_unit: BaseCombatEntity) -> bool:
	if current_target == source_unit:
		current_target = null
		_update_target()
		return current_target != source_unit
	return false

func receive_damage(request: DamageRequest) -> DamageResult:
	if is_backdoor_active:
		# Reduce incoming damage by 70% during backdoor protection
		request.base_damage *= 0.30
	return super.receive_damage(request)

func _execute_tower_attack(target: BaseCombatEntity) -> DamageResult:
	var atk_speed = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	attack_cooldown_timer = 1.0 / maxf(atk_speed, 0.1)
	
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var req = DamageRequest.create_basic_attack(self, target, ad)
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.tower_attack_started.emit(self, target)
	
	# Launch Tower Projectile directly from top Crystal
	if is_inside_tree():
		var proj_script = load("res://scenes/effects/basic_attack_projectile_3d.gd")
		if proj_script != null:
			var proj = proj_script.new()
			get_tree().root.add_child(proj)
			var p_color = Color(0.2, 0.95, 0.4) if team == TeamDefinitions.Team.RADIANT else Color(0.95, 0.2, 0.2)
			var launch_pos = get_crystal_launch_position()
			proj.setup(self, target, req, p_color, 26.0, 0.5, launch_pos)
		else:
			return target.receive_damage(req)
	else:
		return target.receive_damage(req)
		
	return null

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	is_destroyed = true
	
	var enemy_team = TeamDefinitions.Team.DIRE if team == TeamDefinitions.Team.RADIANT else TeamDefinitions.Team.RADIANT
	var killer_hero: HeroEntity = null
	
	if last_attacker is HeroEntity and is_instance_valid(last_attacker):
		killer_hero = last_attacker
	else:
		if killer_name != "":
			for h in HeroEntity.active_heroes:
				if is_instance_valid(h) and (h.entity_name == killer_name or h.entity_name.begins_with(killer_name) or killer_name.begins_with(h.entity_name)):
					killer_hero = h
					break
				
	var total_team_gold = team_bounty_gold * tier
	var objective_xp = 200 * tier
	
	# Award team bounty gold and objective XP to enemy heroes
	for h in HeroEntity.active_heroes:
		if is_instance_valid(h) and h.team == enemy_team:
			if h.inventory_manager != null:
				h.inventory_manager.add_gold(total_team_gold)
			if h.is_alive() and h.attribute_system != null:
				h.attribute_system.add_xp(objective_xp)
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.xp_awarded.emit(h, objective_xp)
					GameEvents.objective_xp_awarded.emit(h, objective_xp, entity_name)
		
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.tower_destroyed.emit(self, killer_hero, total_team_gold)
		GameEvents.combat_log_generated.emit("KULE YIKILDI: %s yok edildi! %s takımındaki her kahramana %dg altın verildi." % [entity_name, ("Radiant" if enemy_team == TeamDefinitions.Team.RADIANT else "Dire"), total_team_gold])
		
	# Multi-stage procedural rubble and shockwave explosion
	if is_inside_tree() and get_parent() != null:
		SpellVisualFX3D.spawn_tower_destruction_sequence(get_parent(), global_position, team == TeamDefinitions.Team.RADIANT)
		
	# Disable collision
	if has_node("TowerCollision"):
		var col = get_node("TowerCollision") as CollisionShape3D
		col.set_deferred("disabled", true)
		
	visible = false

func can_move() -> bool:
	return false
