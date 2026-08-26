class_name SolenHero
extends HeroEntity

## Solen - Ranged Agility Marksman & The Solar Archer

var solar_charges: int = 0
var vault_buff_timer: float = 0.0
var _vault_as_mod_id: String = "solen_vault_as"

func _ready() -> void:
	hero_resource = SolenDefinition.create_solen_resource()
	super._ready()
	_setup_collision()
	_create_solen_visual()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.55
		shape.height = 2.0
		col.shape = shape
		col.position.y = 1.0
		add_child(col)

func _create_solen_visual() -> void:
	if not has_node("SolenVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "SolenVisual"
		add_child(root_vis)
		
		# 1. Body Mesh (Golden/Amber Archer)
		var mesh_inst = MeshInstance3D.new()
		var cyl = CylinderMesh.new()
		cyl.top_radius = 0.38
		cyl.bottom_radius = 0.58
		cyl.height = 1.95
		mesh_inst.mesh = cyl
		mesh_inst.position.y = 0.975
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.95, 0.75, 0.2, 1.0) # Solar Gold
		mat.emission_enabled = true
		mat.emission = Color(0.85, 0.55, 0.1, 1.0)
		mat.emission_energy_multiplier = 0.9
		mesh_inst.material_override = mat
		root_vis.add_child(mesh_inst)
		
		# 2. Golden Solar Crest / Bow on Back
		var crest = MeshInstance3D.new()
		var torus_crest = TorusMesh.new()
		torus_crest.inner_radius = 0.45
		torus_crest.outer_radius = 0.60
		crest.mesh = torus_crest
		crest.position = Vector3(0.0, 1.35, -0.32)
		crest.rotation_degrees = Vector3(90, 0, 0)
		
		var c_mat = StandardMaterial3D.new()
		c_mat.albedo_color = Color(1.0, 0.85, 0.3, 1.0)
		c_mat.emission_enabled = true
		c_mat.emission = Color(1.0, 0.8, 0.2, 1.0)
		c_mat.emission_energy_multiplier = 2.2
		crest.material_override = c_mat
		root_vis.add_child(crest)
		
		# 3. Selection Ring (Thin crisp white/gold ring)
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.90
		torus.outer_radius = 0.95
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(1.0, 0.9, 0.4, 0.9) if team == TeamDefinitions.Team.RADIANT else Color(0.95, 0.3, 0.3, 0.9)
		ring_mat.albedo_color = ring_color
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if vault_buff_timer > 0.0:
		vault_buff_timer -= delta
		if vault_buff_timer <= 0.0:
			_remove_vault_buff()

func execute_basic_attack(target: BaseCombatEntity) -> DamageResult:
	if not TargetRelationSystem.is_valid_basic_attack_target(self, target):
		return null
	if not can_attack():
		return null
		
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.attack_started.emit(self, target)
		
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 54.0
	
	# Solar Charge Passive Check: 5th Hit Proc
	solar_charges += 1
	var is_solar_burst = (solar_charges >= 5)
	if is_solar_burst:
		solar_charges = 0
		var lvl = attribute_system.level if attribute_system != null else 1
		var bonus_solar_dmg = 60.0 + float(lvl) * 20.0
		ad += bonus_solar_dmg
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("SOLEN: GÜNEŞ YÜKÜ PATLAMASI! (+%d Saf Hasar)" % int(bonus_solar_dmg))
			
	var req = DamageRequest.create_basic_attack(self, target, ad)
	req.source_name = entity_name
	
	attack_cooldown = get_attack_interval()
	_play_attack_motion(target, req)
	
	# Solen is a Ranged Marksman: Launch Fast Solar Arrow Projectile
	var proj = BasicAttackProjectile3D.new()
	if get_parent() != null:
		get_parent().add_child(proj)
	else:
		add_child(proj)
	proj.setup(self, target, req, Color(1.0, 0.85, 0.25), 40.0, 0.35, global_position + Vector3(0, 1.2, 0))
	
	return null # Damage delivered upon projectile hit

# ==============================================================================
# ABILITY CASTING LOGIC (Q, W, E, R)
# ==============================================================================
func cast_ability(slot: AbilityResource.Slot, target_point: Vector3 = Vector3.ZERO, target_node: Node = null) -> bool:
	if ability_container == null:
		return false
		
	var ability = ability_container.get_ability(slot)
	if ability == null:
		return false
		
	var lvl = ability_container.get_ability_level(slot)
	if lvl <= 0:
		return false
		
	if not ability_container.can_cast(slot):
		return false
		
	var mana_cost = ability.get_mana_cost(lvl)
	attribute_system.consume_mana(mana_cost)
	ability_container.start_cooldown(slot, ability.get_cooldown(lvl))
	
	match slot:
		AbilityResource.Slot.Q:
			_cast_piercing_arrow(lvl, target_point)
		AbilityResource.Slot.W:
			_cast_blinding_flash(lvl)
		AbilityResource.Slot.E:
			_cast_solar_vault(lvl)
		AbilityResource.Slot.R:
			_cast_supernova_barrage(lvl, target_point)
			
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.ability_cast.emit(self, ability, target_point, target_node)
		
	return true

func _cast_piercing_arrow(lvl: int, target_pos: Vector3) -> void:
	var pos = target_pos if target_pos != Vector3.ZERO else (global_position - global_transform.basis.z * 10.0)
	var aim_dir = (pos - global_position)
	aim_dir.y = 0.0
	if aim_dir.length_squared() < 0.01:
		aim_dir = -global_transform.basis.z
	aim_dir = aim_dir.normalized()
	
	var base_dmg = [90.0, 160.0, 230.0, 300.0][clampi(lvl - 1, 0, 3)]
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * 0.90)
	
	# Pierce through all enemies along line (13m length, 1.6m width)
	var nodes = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	for n in nodes:
		if n is BaseCombatEntity and n != self and is_instance_valid(n) and n.is_alive() and is_enemy_with(n):
			var to_enemy = n.global_position - global_position
			to_enemy.y = 0.0
			var proj_dist = to_enemy.dot(aim_dir)
			if proj_dist >= 0.0 and proj_dist <= 13.0:
				var perp_dist = (to_enemy - (aim_dir * proj_dist)).length()
				if perp_dist <= 1.6:
					var req = DamageRequest.create_spell_damage(self, n, total_dmg, DamageRequest.DamageType.PHYSICAL)
					req.source_name = "Delici Güneş Oku"
					n.receive_damage(req)
					
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("SOLEN: DELİCİ GÜNEŞ OKU FIRLATILDI (%d Hasar)" % int(total_dmg))

func _cast_blinding_flash(lvl: int) -> void:
	var base_dmg = [70.0, 120.0, 170.0, 220.0][clampi(lvl - 1, 0, 3)]
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * 0.50)
	
	var nodes = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	for n in nodes:
		if n is BaseCombatEntity and n != self and is_instance_valid(n) and n.is_alive() and is_enemy_with(n):
			var dist = global_position.distance_to(n.global_position)
			if dist <= 4.5:
				var req = DamageRequest.create_spell_damage(self, n, total_dmg, DamageRequest.DamageType.PHYSICAL)
				req.source_name = "Kör Edici Işık"
				n.receive_damage(req)
				
				# Knock back away from Solen (3.5m push)
				var push_dir = (n.global_position - global_position).normalized()
				push_dir.y = 0.0
				n.global_position += push_dir * 3.5
				
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("SOLEN: KÖR EDİCİ IŞIK PATLATILDI!")

func _cast_solar_vault(lvl: int) -> void:
	# Quick backflip vault dash away from movement/facing
	var back_dir = global_transform.basis.z # Backward
	back_dir.y = 0.0
	global_position += back_dir.normalized() * 5.0
	
	# Grant Attack Speed buff for 4 seconds
	vault_buff_timer = 4.0
	var as_bonus = [0.40, 0.55, 0.70, 0.85][clampi(lvl - 1, 0, 3)]
	
	attribute_system.remove_modifier_by_source(_vault_as_mod_id)
	var mod = StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, as_bonus, _vault_as_mod_id)
	attribute_system.add_modifier(mod)
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("SOLEN: ÇEVİK TAKLA! (+%%%d Saldırı Hızı)" % int(as_bonus * 100))

func _remove_vault_buff() -> void:
	if attribute_system != null:
		attribute_system.remove_modifier_by_source(_vault_as_mod_id)

func _cast_supernova_barrage(lvl: int, target_pos: Vector3) -> void:
	var pos = target_pos if target_pos != Vector3.ZERO else (global_position - global_transform.basis.z * 6.0)
	var base_dmg = [350.0, 550.0, 750.0][clampi(lvl - 1, 0, 2)]
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * 1.10)
	
	var nodes = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	for n in nodes:
		if n is BaseCombatEntity and n != self and is_instance_valid(n) and n.is_alive() and is_enemy_with(n):
			var dist = pos.distance_to(n.global_position)
			if dist <= 6.0:
				var req = DamageRequest.create_spell_damage(self, n, total_dmg, DamageRequest.DamageType.PHYSICAL)
				req.source_name = "Süpernova Yağmuru"
				n.receive_damage(req)
				
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("SOLEN: SÜPERNOVA YAĞMURU! (%d Hasar)" % int(total_dmg))
