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
							var burn_dmg = DamageRequest.create_spell_damage(attacker, target, burned, DamageRequest.DamageType.MAGICAL, "Mana Burn")
							CombatCalculator.execute_damage(burn_dmg)
							
				"ON_HIT_CHAIN_LIGHTNING":
					if not result.is_ability and randf() <= 0.25:
						# 25% Chance chain lightning proc (140 magic damage)
						var l_req = DamageRequest.create_spell_damage(attacker, target, 140.0, DamageRequest.DamageType.MAGICAL, "Chain Lightning")
						CombatCalculator.execute_damage(l_req)

func _process_victim_item_tags(victim: BaseCombatEntity, attacker: BaseCombatEntity, result: DamageResult) -> void:
	var inv: InventoryManager = victim.inventory_manager
	if inv == null:
		return
		
	for item in inv.get_all_equipped_items():
		if item == null:
			continue
			
		for tag in item.item_tags:
			match tag:
				"DEFENSIVE_THORNS":
					if not result.is_ability and attacker != null and attacker.is_alive():
						var reflect_amount = result.final_health_damage * 0.20
						var ref_req = DamageRequest.create_physical_damage(victim, attacker, reflect_amount, "Thorns Reflection")
						CombatCalculator.execute_damage(ref_req)
						
				"DEFENSIVE_LIFELINE":
					if victim.attribute_system != null:
						var max_hp = victim.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
						if victim.attribute_system.current_health <= (max_hp * 0.30):
							if "effect_container" in victim and victim.effect_container != null:
								if not victim.effect_container.has_effect("lifeline_shield"):
									var shield = StatusEffect.new("lifeline_shield", StatusEffect.EffectType.SHIELD, 5.0, 300.0, false)
									victim.effect_container.apply_effect(shield)

func _on_entity_killed(victim: Node, killer: Node) -> void:
	if killer is BaseCombatEntity and "inventory_manager" in killer and killer.inventory_manager != null:
		for item in killer.inventory_manager.get_all_equipped_items():
			if item != null and item.combat_item_tag == "ON_KILL_HEAL":
				if killer.attribute_system != null:
					killer.attribute_system.heal(100.0 + (killer.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) * 0.05))

## Executes an active item slot
static func execute_active_item(user: BaseCombatEntity, item: ItemResource, target: BaseCombatEntity = null, target_pos: Vector3 = Vector3.ZERO) -> bool:
	if user == null or item == null:
		return false
		
	match item.active_action_tag:
		"ACTIVE_BLINK":
			var cur_pos = user.global_position if user.is_inside_tree() else user.position
			var blink_dir = (target_pos - cur_pos).normalized()
			blink_dir.y = 0.0
			var dist = minf(12.0, cur_pos.distance_to(target_pos))
			var shift = blink_dir * (dist if dist > 0.5 else 12.0)
			if user.is_inside_tree():
				user.global_position += shift
			else:
				user.position += shift
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
			var tgt = target if (target != null and is_instance_valid(target)) else user
			if "effect_container" in tgt and tgt.effect_container != null:
				tgt.effect_container.apply_hex(2.8)
			return true
					
		"ACTIVE_FORCE_STAFF":
			var tgt = target if (target != null and is_instance_valid(target)) else user
			if tgt is CharacterBody3D:
				var push_dir = -tgt.transform.basis.z.normalized()
				push_dir.y = 0.0
				if tgt.is_inside_tree():
					tgt.global_position += push_dir * 6.0
				else:
					tgt.position += push_dir * 6.0
			return true
				
		"ACTIVE_BARRIER":
			var tgt = target if (target != null and is_instance_valid(target) and target.team == user.team) else user
			if "effect_container" in tgt and tgt.effect_container != null:
				var shield_eff = StatusEffect.new("shield_barrier", StatusEffect.EffectType.SHIELD, 5.0, 350.0, false)
				tgt.effect_container.apply_effect(shield_eff)
			elif tgt.attribute_system != null:
				tgt.attribute_system.heal(200.0)
			return true
				
		"ACTIVE_HEAL":
			var tgt = target if (target != null and is_instance_valid(target) and target.team == user.team) else user
			if tgt.attribute_system != null:
				tgt.attribute_system.heal(300.0)
			return true
				
		"ACTIVE_SILENCE":
			var tgt = target if (target != null and is_instance_valid(target)) else user
			if "effect_container" in tgt and tgt.effect_container != null:
				tgt.effect_container.apply_silence(3.0)
			return true
				
		"ACTIVE_CLEANSE":
			if "effect_container" in user and user.effect_container != null:
				user.effect_container.clear_all_debuffs()
			return true
				
		"ACTIVE_ATTACK_SPEED_BUFF":
			if user.attribute_system != null:
				var mod = StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.FLAT, 0.40, "item_as_active")
				user.attribute_system.add_modifier(mod)
			return true
				
		"ACTIVE_TRUE_SIGHT_DUST":
			return true
			
		_:
			if user.attribute_system != null:
				user.attribute_system.heal(150.0)
			return true

static func handle_damage_event(result: DamageResult, attacker: BaseCombatEntity, target: BaseCombatEntity) -> void:
	if _instance != null:
		_instance._on_damage_dealt(result, attacker, target)
	else:
		if attacker != null and "inventory_manager" in attacker and attacker.inventory_manager != null:
			for item in attacker.inventory_manager.get_all_equipped_items():
				if item != null and (item.combat_item_tag == "ON_HIT_BLEED" or item.item_tags.has("ON_HIT_BLEED")):
					if target != null and "effect_container" in target and target.effect_container != null:
						var eff = StatusEffect.new("item_on_hit_bleed", StatusEffect.EffectType.DAMAGE_OVER_TIME, 3.0, 15.0, true)
						target.effect_container.apply_effect(eff)

static func handle_kill_event(victim: BaseCombatEntity, killer: BaseCombatEntity) -> void:
	if _instance != null:
		_instance._on_entity_killed(victim, killer)
	else:
		if killer != null and "inventory_manager" in killer and killer.inventory_manager != null:
			if killer.attribute_system != null:
				killer.attribute_system.heal(100.0)
