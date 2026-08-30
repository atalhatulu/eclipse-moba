class_name ItemEventEngine
extends Node

## Centralized Event & Tag-Based Modular Item Engine for Eclipse Front MOBA
## Handles On-Hit, On-Damage, On-Cast, On-Kill, Hybrid Conversions, and Active Item Execution.

static var _instance: ItemEventEngine = null

static func get_instance() -> ItemEventEngine:
	return _instance

func _ready() -> void:
	_instance = self
	_connect_global_events()

func _connect_global_events() -> void:
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		if not GameEvents.damage_dealt.is_connected(_on_damage_dealt):
			GameEvents.damage_dealt.connect(_on_damage_dealt)
		if not GameEvents.entity_killed.is_connected(_on_entity_killed):
			GameEvents.entity_killed.connect(_on_entity_killed)

func _on_damage_dealt(result: DamageResult, attacker: BaseCombatEntity, target: BaseCombatEntity) -> void:
	if attacker == null or target == null:
		return
		
	# 1. Process Attacker On-Hit & On-Damage Passive Tags
	if "inventory_manager" in attacker and attacker.inventory_manager != null:
		_process_attacker_item_tags(attacker, target, result)
		
	# 2. Process Victim Defensive & Reactive Tags
	if "inventory_manager" in target and target.inventory_manager != null:
		_process_victim_item_tags(target, attacker, result)

func _process_attacker_item_tags(attacker: BaseCombatEntity, target: BaseCombatEntity, result: DamageResult) -> void:
	var inv: InventoryManager = attacker.inventory_manager
	if inv == null:
		return
		
	for item in inv.get_all_equipped_items():
		if item == null:
			continue
			
		for tag in item.item_tags:
			match tag:
				"ON_HIT_BLEED":
					# Deal physical DoT bleed over 3s
					if not result.is_ability and target.is_alive():
						var bleed_req = DamageRequest.create_ability_damage(attacker, target, result.final_health_damage * 0.20, DamageRequest.DamageType.PHYSICAL, "Item Bleed")
						CombatCalculator.execute_damage(bleed_req)
						
				"ON_HIT_SLOW":
					if not result.is_ability and "effect_container" in target and target.effect_container != null:
						target.effect_container.apply_slow(0.25, 2.0)
						
				"ON_HIT_MANA_BURN":
					if not result.is_ability and "attribute_system" in target and target.attribute_system != null:
						var burned = minf(35.0, target.attribute_system.current_mana)
						target.attribute_system.current_mana -= burned
						if burned > 0.0:
							var burn_dmg = DamageRequest.create_ability_damage(attacker, target, burned * 0.8, DamageRequest.DamageType.PHYSICAL, "Mana Burn")
							CombatCalculator.execute_damage(burn_dmg)
							
				"ON_HIT_CHAIN_LIGHTNING":
					if not result.is_ability and randf() < 0.25:
						_proc_chain_lightning(attacker, target, 120.0)

func _process_victim_item_tags(victim: BaseCombatEntity, attacker: BaseCombatEntity, result: DamageResult) -> void:
	var inv: InventoryManager = victim.inventory_manager
	if inv == null:
		return
		
	for item in inv.get_all_equipped_items():
		if item == null:
			continue
			
		for tag in item.item_tags:
			match tag:
				"DEFENSIVE_LIFELINE":
					if victim.attribute_system != null:
						var hp_pct = victim.attribute_system.current_health / victim.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
						if hp_pct <= 0.30 and not victim.has_meta("lifeline_cooldown"):
							victim.set_meta("lifeline_cooldown", true)
							victim.attribute_system.apply_shield(300.0 + (victim.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) * 0.15), 4.0)
							get_tree().create_timer(60.0).timeout.connect(func(): if is_instance_valid(victim): victim.remove_meta("lifeline_cooldown"))
							
				"DEFENSIVE_THORNS":
					if not result.is_ability and attacker != null and attacker.is_alive():
						var reflect_dmg = DamageRequest.create_ability_damage(victim, attacker, result.final_health_damage * 0.20, DamageRequest.DamageType.MAGICAL, "Thorns Reflect")
						CombatCalculator.execute_damage(reflect_dmg)

func _proc_chain_lightning(caster: BaseCombatEntity, primary_target: BaseCombatEntity, base_dmg: float) -> void:
	var current_target = primary_target
	var hit_count = 0
	var visited: Array[BaseCombatEntity] = [caster]
	
	while current_target != null and hit_count < 4:
		visited.append(current_target)
		var zap_req = DamageRequest.create_ability_damage(caster, current_target, base_dmg, DamageRequest.DamageType.MAGICAL, "Chain Lightning")
		CombatCalculator.execute_damage(zap_req)
		hit_count += 1
		
		# Find next bounce target
		var next_target: BaseCombatEntity = null
		var min_dist = 6.0
		for ent in caster.get_tree().get_nodes_in_group("combat_entities"):
			if ent is BaseCombatEntity and is_instance_valid(ent) and ent.is_alive() and ent.team != caster.team and not visited.has(ent):
				var d = current_target.global_position.distance_to(ent.global_position)
				if d <= min_dist:
					min_dist = d
					next_target = ent
		current_target = next_target

func _on_entity_killed(victim: BaseCombatEntity, killer: BaseCombatEntity) -> void:
	if killer == null or not is_instance_valid(killer):
		return
	if "inventory_manager" in killer and killer.inventory_manager != null:
		for item in killer.inventory_manager.get_all_equipped_items():
			if item != null and item.item_tags.has("ON_KILL_HEAL"):
				if killer.attribute_system != null:
					killer.attribute_system.heal(100.0 + (killer.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) * 0.05))

## Executes an active item slot
static func execute_active_item(user: BaseCombatEntity, item: ItemResource, target: BaseCombatEntity = null, target_pos: Vector3 = Vector3.ZERO) -> bool:
	if user == null or item == null:
		return false
		
	match item.active_action_tag:
		"ACTIVE_BLINK":
			var blink_dir = (target_pos - user.global_position).normalized()
			blink_dir.y = 0.0
			var dist = minf(12.0, user.global_position.distance_to(target_pos))
			user.global_position += blink_dir * (dist if dist > 0.5 else 12.0)
			return true
			
		"ACTIVE_SPELL_IMMUNITY":
			if "effect_container" in user and user.effect_container != null:
				user.effect_container.apply_spell_immunity(6.0)
				return true
				
		"ACTIVE_CYCLONE":
			var tgt = target if (target != null and is_instance_valid(target)) else user
			if "effect_container" in tgt and tgt.effect_container != null:
				tgt.effect_container.apply_cyclone_lift(2.5)
				return true
				
		"ACTIVE_HEX":
			if target != null and is_instance_valid(target) and target.is_alive() and target.team != user.team:
				if "effect_container" in target and target.effect_container != null:
					target.effect_container.apply_hex(2.8)
					return true
					
		"ACTIVE_FORCE_STAFF":
			var tgt = target if (target != null and is_instance_valid(target)) else user
			if tgt is CharacterBody3D:
				var push_dir = -tgt.global_transform.basis.z.normalized()
				push_dir.y = 0.0
				tgt.global_position += push_dir * 6.0
				return true
				
		"ACTIVE_BARRIER":
			var tgt = target if (target != null and is_instance_valid(target) and tgt.team == user.team) else user
			if tgt.attribute_system != null:
				tgt.attribute_system.apply_shield(350.0, 5.0)
				return true
				
		"ACTIVE_TRUE_SIGHT_DUST":
			var fow = user.get_tree().get_first_node_in_group("fog_of_war")
			# Reveal enemies in 12m radius
			for h in HeroEntity.active_heroes:
				if is_instance_valid(h) and h.team != user.team:
					if h.global_position.distance_to(user.global_position) <= 12.0:
						h.visible = true
			return true
			
		_:
			# Default stat burst or heal
			if user.attribute_system != null:
				user.attribute_system.heal(250.0)
				return true
				
	return false
