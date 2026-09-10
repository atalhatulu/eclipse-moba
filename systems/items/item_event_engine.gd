class_name ItemEventEngine
extends Node

## Centralized Event & Tag-Based Modular Item Engine for Eclipse Front MOBA
## Handles On-Hit, On-Damage, On-Cast, On-Kill, Hybrid Conversions, and Active Item Execution.

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")
const WardEntityClass = preload("res://systems/fog_of_war/ward_entity.gd")

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
						CombatMechanicsClass.burn_mana(attacker, target, 35.0, 1.0, "Mana Burn")
							
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

	# Blade Mail / Thornmail Active Reflection
	if "effect_container" in victim and victim.effect_container != null and victim.effect_container.has_effect("blade_mail_active"):
		if attacker != null and attacker.is_alive() and attacker != victim:
			var reflect_amount = result.final_health_damage * 0.80
			if reflect_amount > 0.0:
				var bm_req = DamageRequest.create_spell_damage(victim, attacker, reflect_amount, DamageRequest.DamageType.TRUE_DAMAGE, "Blade Mail Reflection")
				CombatCalculator.execute_damage(bm_req)

func _on_entity_killed(victim: Node, killer: Node) -> void:
	if killer is BaseCombatEntity and "inventory_manager" in killer and killer.inventory_manager != null:
		for item in killer.inventory_manager.get_all_equipped_items():
			if item != null and item.item_tags.has("ON_KILL_HEAL"):
				if killer.attribute_system != null:
					killer.attribute_system.heal(100.0 + (killer.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) * 0.05))

## Executes an active item slot
static func execute_active_item(user: BaseCombatEntity, item: ItemResource, target: BaseCombatEntity = null, target_pos: Vector3 = Vector3.ZERO) -> bool:
	if user == null or item == null:
		return false
		
	match item.active_action_tag:
		"ACTIVE_REVEAL":
			if not user.is_inside_tree():
				return false
			var origin = user.global_position
			var reveal_count := 0
			for entity in user.get_tree().get_nodes_in_group("combat_entities"):
				if entity is BaseCombatEntity and is_instance_valid(entity) and entity.team != user.team:
					if origin.distance_to(entity.global_position) <= 15.0:
						entity.set_meta("reveal_until_msec", Time.get_ticks_msec() + 6000)
						reveal_count += 1
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s Oracle Lens kullandı: %d birim ifşa edildi." % [user.entity_name, reveal_count])
			return true

		"ACTIVE_OBSERVER_WARD", "ACTIVE_SENTRY_WARD":
			if target_pos == Vector3.ZERO or not user.is_inside_tree():
				return false
			var ward := WardEntityClass.new()
			ward.team = user.team
			ward.placed_by = user
			var is_sentry := item.active_action_tag == "ACTIVE_SENTRY_WARD"
			ward.ward_name = "Sentry Ward" if is_sentry else "Observer Ward"
			ward.vision_radius = 10.0 if is_sentry else 15.0
			ward.true_sight_radius = 11.0 if is_sentry else 0.0
			ward.duration = 240.0 if is_sentry else 360.0
			var root = user.get_tree().current_scene if user.get_tree().current_scene != null else user.get_tree().root
			root.add_child(ward)
			ward.global_position = target_pos
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s %s yerleştirdi." % [user.entity_name, ward.ward_name])
			return true

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
			CombatMechanicsClass.apply_shield(user, tgt, "shield_barrier", "Bariyer", 350.0, 5.0)
			return true
				
		"ACTIVE_BURST_HEAL", "ACTIVE_HEAL":
			var tgt = target if (target != null and is_instance_valid(target) and target.team == user.team) else user
			var ap = user.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if user.attribute_system != null else 0.0
			var heal_val = 300.0 + (ap * 0.35)
			CombatMechanicsClass.heal(user, tgt, heal_val, item.item_name)
			return true
			
		"ACTIVE_EXECUTION":
			if target != null and is_instance_valid(target) and target.is_alive() and target.team != user.team:
				CombatMechanicsClass.execute_missing_health_damage(user, target, 180.0, 0.20, "Execution Strike")
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
				
		"ACTIVE_REFRESHER":
			if "ability_container" in user and user.ability_container != null:
				user.ability_container.reset_all_cooldowns(1.0)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s Refresher kullandı: Tüm yetenek bekleme süreleri sıfırlandı." % user.entity_name)
			return true

		"ACTIVE_DAGON":
			var tgt = target if (target != null and is_instance_valid(target) and target.is_alive() and target.team != user.team) else null
			if tgt == null and user.is_inside_tree():
				var cur_pos = user.global_position
				var min_dist = 12.0
				for entity in user.get_tree().get_nodes_in_group("combat_entities"):
					if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != user.team:
						var d = cur_pos.distance_to(entity.global_position)
						if d <= min_dist:
							min_dist = d
							tgt = entity
			if tgt != null and is_instance_valid(tgt):
				var ap = user.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if user.attribute_system != null else 0.0
				var dagon_dmg = 500.0 + (ap * 0.75)
				var d_req = DamageRequest.create_spell_damage(user, tgt, dagon_dmg, DamageRequest.DamageType.MAGICAL, item.item_name)
				CombatCalculator.execute_damage(d_req)
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.combat_log_generated.emit("%s %s ile %s hedefine %.0f büyü hasarı verdi." % [user.entity_name, item.item_name, tgt.entity_name, dagon_dmg])
				return true
			return false

		"ACTIVE_FROST_NOVA":
			if not user.is_inside_tree():
				return false
			var origin = user.global_position
			var hit_count := 0
			for entity in user.get_tree().get_nodes_in_group("combat_entities"):
				if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != user.team:
					if origin.distance_to(entity.global_position) <= 10.0:
						var nova_req = DamageRequest.create_spell_damage(user, entity, 250.0, DamageRequest.DamageType.MAGICAL, item.item_name)
						CombatCalculator.execute_damage(nova_req)
						if "effect_container" in entity and entity.effect_container != null:
							entity.effect_container.apply_slow(0.45, 4.0)
						hit_count += 1
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s Buz Patlaması tetikledi (%d düşman donduruldu/yavaşlatıldı)." % [user.entity_name, hit_count])
			return true

		"ACTIVE_BLADE_MAIL":
			if "effect_container" in user and user.effect_container != null:
				var bm_eff = StatusEffect.new("blade_mail_active", StatusEffect.EffectType.BUFF, 4.5, 1.0, false)
				user.effect_container.apply_effect(bm_eff)
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.combat_log_generated.emit("%s Thornmail Dikenli Zırh açtı: Hasarın %%80'i yansıtılacak." % user.entity_name)
			return true

		"ACTIVE_LOTUS_ORB":
			var tgt = target if (target != null and is_instance_valid(target) and target.team == user.team) else user
			if "effect_container" in tgt and tgt.effect_container != null:
				tgt.effect_container.clear_all_debuffs()
				tgt.effect_container.apply_spell_immunity(3.0)
			CombatMechanicsClass.apply_shield(user, tgt, "lotus_echo_shield", "Lotus Kalkanı", 400.0, 5.0)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s, %s üzerine Lotus Kalkanı uyguladı." % [user.entity_name, tgt.entity_name])
			return true

		"ACTIVE_ARMLET":
			if user.effect_container == null:
				return false
			if user.effect_container.has_effect("armlet_unholy_strength"):
				user.effect_container.remove_effect("armlet_unholy_strength")
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.combat_log_generated.emit("%s Blood Engine kapattı." % user.entity_name)
			else:
				var armlet_buff = StatusEffect.new("armlet_unholy_strength", StatusEffect.EffectType.STAT_MODIFIER, 10.0, 65.0, false)
				armlet_buff.target_stat = StatModifier.TargetStat.ATTACK_DAMAGE
				armlet_buff.stat_mod_type = StatModifier.Type.FLAT
				user.effect_container.apply_effect(armlet_buff)
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.combat_log_generated.emit("%s Blood Engine aktifleştirdi (+65 Saldırı Gücü)." % user.entity_name)
			return true

		"ACTIVE_MANTA":
			if "effect_container" in user and user.effect_container != null:
				user.effect_container.clear_all_debuffs()
				var manta_haste = StatusEffect.new("manta_phantasm_haste", StatusEffect.EffectType.STAT_MODIFIER, 5.0, 60.0, false)
				manta_haste.target_stat = StatModifier.TargetStat.MOVE_SPEED
				manta_haste.stat_mod_type = StatModifier.Type.FLAT
				user.effect_container.apply_effect(manta_haste)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s Spirit Core arınma ve illüzyon hızı kazandı." % user.entity_name)
			return true

		"ACTIVE_TIME_REWIND":
			if user.attribute_system != null:
				var max_hp = user.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
				var missing = max_hp - user.attribute_system.current_health
				user.attribute_system.heal(missing * 0.40)
			if "ability_container" in user and user.ability_container != null:
				user.ability_container.reset_all_cooldowns(0.50)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s Zamanı Geri Aldı: Can tazelendi ve bekleme süreleri %%50 azaldı." % user.entity_name)
			return true

		"ACTIVE_ATTACK_SPEED_BUFF":
			# Use the effect container so the stat modifier always expires and is
			# represented by the existing status-effect UI.
			if user.effect_container == null:
				return false
			var haste = StatusEffect.new("item_attack_speed_active", StatusEffect.EffectType.STAT_MODIFIER, 5.0, 0.40, false)
			haste.target_stat = StatModifier.TargetStat.ATTACK_SPEED
			haste.stat_mod_type = StatModifier.Type.FLAT
			user.effect_container.apply_effect(haste)
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
				if item != null and item.item_tags.has("ON_HIT_BLEED"):
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
