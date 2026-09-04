class_name ZinHero
extends HeroEntity

## Implementation of Zin

const DefScript = preload("res://data/heroes/zin_definition.gd")

func _ready() -> void:
	entity_name = "Zin"
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
	if not has_node("ZinVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "ZinVisual"
		add_child(root_vis)
		
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.52
		body_capsule.height = 2.0
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.0
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.70, 0.85, 0.95)
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)

var active_mirror_clone: Node3D = null
var mirror_clone_position: Vector3 = Vector3.ZERO
var mirror_clone_remaining: float = 0.0

func _process(delta: float) -> void:
	super._process(delta)
	if mirror_clone_remaining > 0.0:
		mirror_clone_remaining = maxf(0.0, mirror_clone_remaining - delta)
		if mirror_clone_remaining <= 0.0:
			_clear_mirror_clone()

func _has_mirror_clone() -> bool:
	return mirror_clone_remaining > 0.0

func _clear_mirror_clone() -> void:
	if active_mirror_clone != null and is_instance_valid(active_mirror_clone):
		active_mirror_clone.queue_free()
	active_mirror_clone = null
	mirror_clone_position = Vector3.ZERO
	mirror_clone_remaining = 0.0

func _apply_def() -> void:
	var def = DefScript.create_resource()
	_apply_hero_resource(def)
	hero_resource = def
	
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

# --- Q: MIRROR MIRAGE ---

func cast_zin_q(target_point: Vector3, targets: Array = []) -> DamageResult:
	var my_pos = global_position if is_inside_tree() else position
	
	# Despawn previous clone if any
	_clear_mirror_clone()
	mirror_clone_position = target_point
	mirror_clone_remaining = 6.0
		
	# Spawn 3D Mirror Clone at target_point
	if is_inside_tree():
		var clone_script = load("res://scenes/effects/zin_mirror_clone_3d.gd")
		if clone_script != null:
			active_mirror_clone = clone_script.new()
			get_tree().root.add_child(active_mirror_clone)
			active_mirror_clone.global_position = target_point
			
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1) if ability_container != null else 1
	var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 80.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 52.0
	var total_dmg = base_dmg + (ad * 0.85)
	
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
			if target_point.distance_to(e_pos) <= 3.5 or my_pos.distance_to(e_pos) <= 3.5:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.PHYSICAL, "Mirror Mirage")
				var res = CombatCalculator.execute_damage(req)
				if primary_res == null:
					primary_res = res
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("ZIN: AYNA İKİZİ OLUŞTURULDU! (6.0s Aktif)")
	return primary_res

# --- W: MIRROR SWAP ---

func cast_zin_w() -> bool:
	var my_pos = global_position if is_inside_tree() else position
	if not _has_mirror_clone():
		return false
	var clone_pos = mirror_clone_position
	if active_mirror_clone != null and is_instance_valid(active_mirror_clone):
		clone_pos = active_mirror_clone.global_position
		
	# Swap positions
	if is_inside_tree():
		global_position = clone_pos
		if active_mirror_clone != null and is_instance_valid(active_mirror_clone):
			active_mirror_clone.global_position = my_pos
	else:
		position = clone_pos
	mirror_clone_position = my_pos
		
	# Spawn Glass Shatter at both positions
	if is_inside_tree():
		var shatter_script = load("res://scenes/effects/zin_glass_shatter_3d.gd")
		if shatter_script != null:
			var s1 = shatter_script.new()
			get_tree().root.add_child(s1)
			s1.global_position = my_pos
			
			var s2 = shatter_script.new()
			get_tree().root.add_child(s2)
			s2.global_position = clone_pos
			
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("ZIN: AYNA TAKASI GERÇEKLEŞTİ! (Cam Kırılması Patlaması)")
	return true

# --- E: GLASS SHARDS ---

func cast_zin_e() -> bool:
	var my_pos = global_position if is_inside_tree() else position
	var clone_pos = mirror_clone_position if _has_mirror_clone() else my_pos
	if active_mirror_clone != null and is_instance_valid(active_mirror_clone):
		clone_pos = active_mirror_clone.global_position
	
	# Spawn Glass Shatter VFX
	if is_inside_tree():
		var shatter_script = load("res://scenes/effects/zin_glass_shatter_3d.gd")
		if shatter_script != null:
			var s1 = shatter_script.new()
			get_tree().root.add_child(s1)
			s1.global_position = my_pos
			if clone_pos != my_pos:
				var s2 = shatter_script.new()
				get_tree().root.add_child(s2)
				s2.global_position = clone_pos
				
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1) if ability_container != null else 1
	var base_dmg = e_res.get_base_damage(lvl) if e_res != null else 80.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var total_dmg = base_dmg + (ap * 0.75)
	
	var enemies: Array = []
	if is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		enemies.append_array(CreepEntity.active_creeps)
		
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and is_enemy_with(e) and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if my_pos.distance_to(e_pos) <= 5.0 or clone_pos.distance_to(e_pos) <= 5.0:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Glass Shards")
				CombatCalculator.execute_damage(req)
				if e.effect_container != null:
					var bleed_eff = StatusEffect.new("zin_glass_bleed", StatusEffect.EffectType.DAMAGE_OVER_TIME, 3.0, 15.0, true)
					bleed_eff.source_entity = self
					e.effect_container.apply_effect(bleed_eff)
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("ZIN: DÖNEN CAM KIRIKLARI SAÇILDI! (Büyü Hasarı ve Kanama)")
	return true

# --- R: HALL OF MIRRORS (ULTIMATE) ---

func cast_zin_r(target_location: Vector3, enemies_in_area: Array = []) -> bool:
	# Spawn 3D Hall of Mirrors Vortex
	if is_inside_tree():
		var hall_script = load("res://scenes/effects/zin_hall_of_mirrors_3d.gd")
		if hall_script != null:
			var hall = hall_script.new()
			get_tree().root.add_child(hall)
			hall.setup(target_location, 6.0)
			
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1) if ability_container != null else 1
	var base_dmg = r_res.get_base_damage(lvl) if r_res != null else 250.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 52.0
	var total_dmg = base_dmg + (ad * 1.25)
	
	var enemies = enemies_in_area.duplicate()
	if enemies.is_empty():
		if is_inside_tree() and get_tree() != null:
			enemies = get_tree().get_nodes_in_group("combat_entities")
		else:
			enemies.append_array(HeroEntity.active_heroes)
			enemies.append_array(CreepEntity.active_creeps)
			
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and is_enemy_with(e) and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if target_location.distance_to(e_pos) <= 6.0:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.PHYSICAL, "Hall of Mirrors")
				CombatCalculator.execute_damage(req)
				if e.effect_container != null:
					var stun_eff = StatusEffect.new("zin_hall_stun", StatusEffect.EffectType.STUN, 1.5, 0.0, true)
					stun_eff.source_entity = self
					e.effect_container.apply_effect(stun_eff)
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("ZIN: AYNALAR SALONU! (3 İkiz Hücumu ve 1.5s Sersemletme)")
	return true
