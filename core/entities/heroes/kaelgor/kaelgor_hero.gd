class_name KaelgorHero
extends HeroEntity

## Implementation of Kaelgor (The Furnace Heart / Bruiser)

signal heat_updated(current_heat: float, max_heat: float)
signal iron_hide_activated()
signal iron_hide_ended()
signal overheat_activated()
signal overheat_ended()

var heat_system: HeatSystem = null

# State flags
var is_iron_hide_active: bool = false
var iron_hide_timer: float = 0.0
var is_overheated: bool = false
var overheat_timer: float = 0.0

# Heat generation constants
const HEAT_PER_DAMAGE_TAKEN: float = 0.06 # ~6 Heat per 100 damage taken
const IRON_HIDE_REDUCTION: float = 0.30 # 30% damage reduction
const IRON_HIDE_HEAT_CONVERSION: float = 0.50 # 50% of prevented damage becomes Heat

func _ready() -> void:
	entity_name = "Kaelgor"
	
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_setup_heat_system()
	_apply_kaelgor_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.65
		shape.height = 2.2
		col.shape = shape
		col.position.y = 1.1
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("KaelgorVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "KaelgorVisual"
		add_child(root_vis)
		
		# Torso / Body (Molten Armored Capsule - 2.2m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.60
		body_capsule.height = 2.2
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.1
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.18, 0.16, 0.16, 1.0) # Dark Obsidian Armor
		body_mat.metallic = 0.85
		body_mat.roughness = 0.35
		body_mat.emission_enabled = true
		body_mat.emission = Color(0.95, 0.4, 0.1, 1.0) # Molten Fire Glow
		body_mat.emission_energy_multiplier = 1.2
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Heavy Shoulder Pauldrons
		for side in [-0.70, 0.70]:
			var shoulder = MeshInstance3D.new()
			var sh_box = BoxMesh.new()
			sh_box.size = Vector3(0.45, 0.45, 0.55)
			shoulder.mesh = sh_box
			shoulder.position = Vector3(side, 1.70, 0.0)
			
			var sh_mat = StandardMaterial3D.new()
			sh_mat.albedo_color = Color(0.85, 0.3, 0.1, 1.0)
			sh_mat.emission_enabled = true
			sh_mat.emission = Color(1.0, 0.5, 0.1, 1.0)
			sh_mat.emission_energy_multiplier = 1.5
			shoulder.material_override = sh_mat
			root_vis.add_child(shoulder)
			
		# Selection Base Ring (Thin crisp ring, kulevehero.png reference)
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.90
		torus.outer_radius = 0.95
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _setup_heat_system() -> void:
	if not has_node("HeatSystem"):
		heat_system = HeatSystem.new()
		heat_system.name = "HeatSystem"
		add_child(heat_system)
	else:
		heat_system = $HeatSystem
		
	heat_system.heat_changed.connect(func(c, m): heat_updated.emit(c, m))

func _apply_kaelgor_definition() -> void:
	var def = KaelgorDefinition.create_resource()
	
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
	
	# Process Iron Hide timer
	if is_iron_hide_active:
		iron_hide_timer -= delta
		if iron_hide_timer <= 0.0:
			_end_iron_hide()
			
	# Process Overheat timer
	if is_overheated:
		overheat_timer -= delta
		if overheat_timer <= 0.0:
			_end_overheat()

# --- COMBAT & BASIC ATTACK OVERRIDES ---

func execute_basic_attack(target: BaseCombatEntity) -> DamageResult:
	if target == null or not is_alive() or not can_attack() or not target.is_alive() or not target.is_targetable:
		return null
		
	# Friendly team check: cannot attack teammates
	if target.team == team:
		return null
		
	# Attack range validation
	var attack_range = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	if global_position.distance_to(target.global_position) > (attack_range + 50.0): # Tolerant check
		return null
		
	var res = super.execute_basic_attack(target)
	if res != null and heat_system != null:
		heat_system.notify_combat_activity()
		heat_system.add_heat(10.0) # +10 Heat on basic attack
		
		# Overheat Splash Damage: 50% splash damage to nearby enemies around target
		if is_overheated:
			_execute_overheat_splash(target, res.final_health_damage * 0.50)
			
	return res

func _execute_overheat_splash(main_target: BaseCombatEntity, splash_dmg: float) -> void:
	if main_target == null or splash_dmg <= 0.0:
		return
	var main_pos = main_target.global_position if (main_target.is_inside_tree() or main_target.global_position != Vector3.ZERO) else main_target.position
	var enemies: Array = []
	if is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		enemies.append_array(CreepEntity.active_creeps)
		
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e != main_target and e.is_alive() and e.team != team and e.is_targetable:
			var e_pos = e.global_position if (e.is_inside_tree() or e.global_position != Vector3.ZERO) else e.position
			var dist = main_pos.distance_to(e_pos)
			if dist <= 4.0 or dist <= 400.0:
				var splash_req = DamageRequest.create_ability_damage(self, e, splash_dmg, DamageRequest.DamageType.PHYSICAL, "Overheat Splash")
				CombatCalculator.execute_damage(splash_req)

# --- DAMAGE RECEIVING & PASSIVE (FURNACE HEART) ---

func receive_damage(request: DamageRequest) -> DamageResult:
	if not is_alive():
		return null
		
	var raw_damage = request.base_damage
	
	# Iron Hide damage reduction calculation
	if is_iron_hide_active and request.damage_type != DamageRequest.DamageType.TRUE_DAMAGE:
		var prevented = raw_damage * IRON_HIDE_REDUCTION
		request.base_damage = maxf(0.0, raw_damage - prevented)
		
		# Generate Heat from prevented damage (no recursion!)
		if heat_system != null and prevented > 0.0:
			heat_system.add_heat(prevented * IRON_HIDE_HEAT_CONVERSION * HEAT_PER_DAMAGE_TAKEN * 2.0)
			
	var result = super.receive_damage(request)
	
	# Furnace Heart passive: Generate Heat on valid combat damage
	if result != null and heat_system != null and (result.final_health_damage > 0.0 or result.shield_absorbed > 0.0):
		var total_taken = result.final_health_damage + result.shield_absorbed
		var heat_gain = total_taken * HEAT_PER_DAMAGE_TAKEN
		heat_system.add_heat(heat_gain)
		
	return result

# --- ABILITY IMPLEMENTATIONS ---

func cast_kaelgor_q(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not target.is_alive() or target.team == team:
		return false
	if heat_system != null:
		heat_system.notify_combat_activity()
		
	# Spawn Molten Fist VFX on target
	if is_inside_tree():
		var fist_script = load("res://scenes/effects/kaelgor_molten_fist_3d.gd")
		if fist_script != null:
			var fist = fist_script.new()
			get_tree().root.add_child(fist)
			fist.global_position = target.global_position
			
	return ability_container.cast_ability(AbilityResource.Slot.Q, target)

func cast_kaelgor_w(nearby_targets: Array = []) -> bool:
	if not can_cast():
		return false
		
	# Spawn Radial Vent Blast VFX
	if is_inside_tree():
		var vent_script = load("res://scenes/effects/kaelgor_vent_blast_3d.gd")
		if vent_script != null:
			var blast = vent_script.new()
			get_tree().root.add_child(blast)
			blast.global_position = global_position
			
	if heat_system != null:
		heat_system.consume_heat(heat_system.get_heat())
		heat_system.notify_combat_activity()
	return ability_container.cast_ability(AbilityResource.Slot.W)

func cast_kaelgor_e() -> bool:
	if not can_cast():
		return false
	is_iron_hide_active = true
	iron_hide_timer = 4.0
	if heat_system != null:
		heat_system.notify_combat_activity()
	iron_hide_activated.emit()
	return ability_container.cast_ability(AbilityResource.Slot.E)

func cast_kaelgor_r() -> bool:
	if not can_cast():
		return false
	is_overheated = true
	overheat_timer = 8.0
	if heat_system != null:
		heat_system.set_heat(100.0)
		heat_system.is_decay_locked = true
		
	# Spawn Overheat Aura VFX
	if is_inside_tree():
		var aura_script = load("res://scenes/effects/kaelgor_overheat_aura_3d.gd")
		if aura_script != null:
			var aura = aura_script.new()
			add_child(aura)
			aura.position = Vector3.ZERO
			
	overheat_activated.emit()
	return ability_container.cast_ability(AbilityResource.Slot.R)

func _end_iron_hide() -> void:
	is_iron_hide_active = false
	iron_hide_timer = 0.0
	effect_container.remove_effect_by_id("kaelgor_iron_hide")
	iron_hide_ended.emit()

func _end_overheat() -> void:
	is_overheated = false
	overheat_timer = 0.0
	if heat_system != null:
		heat_system.is_decay_locked = false
	effect_container.remove_effect_by_id("kaelgor_overheat")
	overheat_ended.emit()

# --- DEATH & RESPAWN OVERRIDES ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	
	_end_iron_hide()
	_end_overheat()
	
	if heat_system != null:
		heat_system.reset_heat()

func respawn() -> void:
	super.respawn()
	if heat_system != null:
		heat_system.reset_heat()
