class_name InventoryManager
extends Node

## Manages 6 standard item slots + 1 dedicated boots slot, recipe resolution, gold, and stat bonuses

signal inventory_updated()
signal boots_slot_updated(boots_item: ItemResource)
signal gold_updated(current_gold: int)
signal item_purchased(item: ItemResource, cost_paid: int)
signal item_sold(item: ItemResource, refund_gold: int)

const MAX_NORMAL_SLOTS = 6

@export var gold: int = 600
@export var unlimited_gold_mode: bool = false

var slots: Array[ItemResource] = []
var boots_slot: ItemResource = null
var attribute_system: AttributeSystem = null

func _init() -> void:
	_ensure_slots()

func _ready() -> void:
	_resolve_attribute_system()
	_ensure_slots()

func _ensure_slots() -> void:
	if slots.size() < MAX_NORMAL_SLOTS:
		slots.resize(MAX_NORMAL_SLOTS)
		for i in range(MAX_NORMAL_SLOTS):
			slots[i] = null

func _resolve_attribute_system() -> void:
	if attribute_system == null and get_parent() != null:
		if "attribute_system" in get_parent() and get_parent().attribute_system != null:
			attribute_system = get_parent().attribute_system
		else:
			attribute_system = get_parent().get_node_or_null("AttributeSystem")

func add_gold(amount: int) -> void:
	gold += amount
	gold_updated.emit(gold)

func spend_gold(amount: int) -> bool:
	if unlimited_gold_mode:
		return true
	if amount <= 0:
		return true
	if gold < amount:
		return false
	gold -= amount
	gold_updated.emit(gold)
	return true

func has_empty_normal_slot() -> bool:
	_ensure_slots()
	for s in slots:
		if s == null:
			return true
	return false

## Purchases and crafts an item, automatically taking owned recipe components into account
func buy_item(target_item: ItemResource, item_lookup_func: Callable = Callable()) -> bool:
	if target_item == null:
		return false
		
	_ensure_slots()
	var solution = ItemTreeResolver.resolve_crafting(target_item, gold, slots, boots_slot, item_lookup_func)
	if not solution.can_afford or not solution.has_space:
		return false
		
	# Deduct gold
	spend_gold(solution.final_gold_cost)
	
	# Consume components from normal slots
	# Sort in descending order to avoid index shifting
	var to_consume = solution.normal_slots_to_consume.duplicate()
	to_consume.sort()
	to_consume.reverse()
	for slot_idx in to_consume:
		slots[slot_idx] = null
		_remove_stat_modifiers("slot_%d" % slot_idx)
		
	# Consume boots slot if applicable
	if solution.consumes_boots_slot:
		boots_slot = null
		_remove_stat_modifiers("boots_slot")
		
	# Equip target item
	if target_item.is_boots():
		if boots_slot == null:
			boots_slot = target_item
			_apply_stat_modifiers(target_item, "boots_slot")
			boots_slot_updated.emit(boots_slot)
		else:
			# If boots slot was somehow occupied and not consumed, put in normal slot
			_place_in_first_free_slot(target_item)
	else:
		_place_in_first_free_slot(target_item)
		
	inventory_updated.emit()
	item_purchased.emit(target_item, solution.final_gold_cost)
	return true

func _place_in_first_free_slot(item: ItemResource) -> bool:
	_ensure_slots()
	for i in range(MAX_NORMAL_SLOTS):
		if slots[i] == null:
			slots[i] = item
			_apply_stat_modifiers(item, "slot_%d" % i)
			return true
	return false

func sell_item(slot_index: int) -> bool:
	_ensure_slots()
	if slot_index < 0 or slot_index >= MAX_NORMAL_SLOTS:
		return false
	var item = slots[slot_index]
	if item == null:
		return false
		
	slots[slot_index] = null
	_remove_stat_modifiers("slot_%d" % slot_index)
	
	var refund = int(round(float(item.cost) * 0.70))
	add_gold(refund)
	inventory_updated.emit()
	item_sold.emit(item, refund)
	return true

func sell_boots() -> bool:
	if boots_slot == null:
		return false
	var item = boots_slot
	boots_slot = null
	_remove_stat_modifiers("boots_slot")
	
	var refund = int(round(float(item.cost) * 0.70))
	add_gold(refund)
	boots_slot_updated.emit(null)
	inventory_updated.emit()
	item_sold.emit(item, refund)
	return true

func _apply_stat_modifiers(item: ItemResource, slot_tag: String) -> void:
	_resolve_attribute_system()
	if attribute_system == null:
		return
		
	for target_stat in item.stat_bonuses.keys():
		var val = item.stat_bonuses[target_stat]
		var mod = StatModifier.new(target_stat, StatModifier.Type.FLAT, val, "item_" + slot_tag)
		attribute_system.add_modifier(mod)

var active_cooldowns: Dictionary = {} # slot_idx -> float

func _process(delta: float) -> void:
	for slot_idx in active_cooldowns.keys():
		if active_cooldowns[slot_idx] > 0.0:
			active_cooldowns[slot_idx] -= delta
			if active_cooldowns[slot_idx] <= 0.0:
				active_cooldowns.erase(slot_idx)
				inventory_updated.emit()

func use_active_item(slot_index: int, target_entity: BaseCombatEntity = null, target_pos: Vector3 = Vector3.ZERO) -> bool:
	if slot_index < 0 or slot_index >= MAX_NORMAL_SLOTS:
		return false
		
	var item = slots[slot_index]
	if item == null:
		return false
		
	if active_cooldowns.get(slot_index, 0.0) > 0.0:
		return false
		
	var parent_hero = get_parent() as HeroEntity
	if parent_hero == null or not parent_hero.is_alive():
		return false
		
	var cd = 10.0
	var triggered = false
	
	match item.id:
		114: # Lifebloom (Heal 300 HP)
			cd = 12.0
			var heal_target = target_entity if (target_entity != null and target_entity.team == parent_hero.team) else parent_hero
			var heal_val = 300.0 + (parent_hero.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) * 0.4)
			heal_target.attribute_system.heal(heal_val)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s LIFEBLOOM KULLANDI (+%.0f CAN)" % [parent_hero.entity_name, heal_val])
			triggered = true
		115: # Radiant Aegis (Shield 350 HP for 4s)
			cd = 14.0
			var shield_target = target_entity if (target_entity != null and target_entity.team == parent_hero.team) else parent_hero
			if shield_target != null and shield_target.effect_container != null:
				var shield_eff = StatusEffect.new("shield_radiant_aegis", StatusEffect.EffectType.SHIELD, 4.0, 350.0, false)
				shield_target.effect_container.apply_effect(shield_eff)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s RADIANT AEGIS KALKANI AÇTI (350 Kalkan)" % parent_hero.entity_name)
			triggered = true
		118: # Force Relic (Dash 6m)
			cd = 12.0
			var forward_dir = -parent_hero.global_transform.basis.z.normalized()
			if target_pos != Vector3.ZERO:
				forward_dir = (target_pos - parent_hero.global_position).normalized()
				forward_dir.y = 0.0
			parent_hero.global_position += forward_dir * 6.0
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s FORCE RELIC İLE İLERİ ATILDI" % parent_hero.entity_name)
			triggered = true
		119: # Timekeeper (Reset 40% Cooldowns)
			cd = 20.0
			if parent_hero.ability_container != null:
				for s in parent_hero.ability_container.cooldown_timers.keys():
					parent_hero.ability_container.cooldown_timers[s] *= 0.6
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s TIMEKEEPER İLE BEKLEME SÜRELERİNİ KISALTTI" % parent_hero.entity_name)
			triggered = true
		73: # Bloodfang (Active: +40% AS for 5s)
			cd = 15.0
			var as_mod = StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.FLAT, 0.40, "bloodfang_active")
			parent_hero.attribute_system.add_modifier(as_mod)
			if get_tree() != null:
				get_tree().create_timer(5.0).timeout.connect(func():
					if is_instance_valid(parent_hero) and parent_hero.attribute_system != null:
						parent_hero.attribute_system.remove_modifiers_by_source("bloodfang_active")
				)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s KAN DİŞİ (BLOODFANG) ÖFKESİNİ AÇTI (+%%40 Hız)" % parent_hero.entity_name)
			triggered = true
		74: # Executioner's Blade (Deal 250 + 20% Missing HP)
			cd = 18.0
			var enemy = target_entity
			if enemy != null and enemy.team != parent_hero.team and enemy.is_alive():
				var missing_hp = enemy.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) - enemy.attribute_system.current_health
				var exec_dmg = 250.0 + (missing_hp * 0.20)
				var req = DamageRequest.create_spell_damage(parent_hero, enemy, exec_dmg, DamageRequest.DamageType.TRUE_DAMAGE, "Executioner's Blade")
				enemy.receive_damage(req)
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.combat_log_generated.emit("%s İNFAZ KILICI VURDU (%.0f Gerçek Hasar)" % [parent_hero.entity_name, exec_dmg])
				triggered = true
		83: # Titan Slayer (Cleanse CC + 40% MS for 3s)
			cd = 16.0
			if parent_hero.effect_container != null:
				parent_hero.effect_container.clear_all_debuffs()
			var ms_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.40, "titan_slayer_active")
			parent_hero.attribute_system.add_modifier(ms_mod)
			if get_tree() != null:
				get_tree().create_timer(3.0).timeout.connect(func():
					if is_instance_valid(parent_hero) and parent_hero.attribute_system != null:
						parent_hero.attribute_system.remove_modifiers_by_source("titan_slayer_active")
				)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s TITAN SLAYER AKTİFLEŞTİRDİ" % parent_hero.entity_name)
			triggered = true
		_:
			# Generic Heal for any active item
			cd = 10.0
			parent_hero.attribute_system.heal(200.0)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("%s EŞYA KULLANDI (+200 Can)" % parent_hero.entity_name)
			triggered = true
			
	if triggered:
		active_cooldowns[slot_index] = cd
		inventory_updated.emit()
		return true
		
	return false

func _remove_stat_modifiers(slot_tag: String) -> void:
	_resolve_attribute_system()
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("item_" + slot_tag)
