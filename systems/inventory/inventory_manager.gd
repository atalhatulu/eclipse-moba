class_name InventoryManager
extends Node

## Manages 6 standard item slots + 1 dedicated boots slot, recipe resolution, gold, and stat bonuses

signal inventory_updated()
signal boots_slot_updated(boots_item: ItemResource)
signal gold_updated(current_gold: int)
signal item_purchased(item: ItemResource, cost_paid: int)
signal item_sold(item: ItemResource, refund_gold: int)

const MAX_NORMAL_SLOTS = 6
const ItemEventEngineClass = preload("res://systems/items/item_event_engine.gd")
const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")
const ItemPickup3DClass = preload("res://scenes/entities/item_pickup_3d.gd")
const CourierManagerClass = preload("res://systems/courier/courier_manager.gd")
const CourierEntityClass = preload("res://systems/courier/courier_entity.gd")

@export var gold: int = 600
@export var unlimited_gold_mode: bool = false
@export var passive_gold_enabled: bool = true
@export var passive_gold_rate: float = 2.0 # 2.0 gold/sec
var _passive_gold_accumulator: float = 0.0

var slots: Array[ItemResource] = []
var active_cooldowns: Dictionary = {} # slot_idx -> float
var boots_slot: ItemResource = null
var attribute_system: AttributeSystem = null
var host_entity: BaseCombatEntity = null
## Human-readable outcome for UI, Quick Buy, and telemetry consumers.
var last_purchase_failure_reason: String = ""

func _init() -> void:
	slots = []
	active_cooldowns = {}
	_ensure_slots()

func _ready() -> void:
	if host_entity == null and get_parent() is BaseCombatEntity:
		host_entity = get_parent() as BaseCombatEntity
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

func tick_passive_gold(delta: float) -> int:
	_passive_gold_accumulator += delta * passive_gold_rate
	if _passive_gold_accumulator >= 1.0:
		var gained = int(_passive_gold_accumulator)
		_passive_gold_accumulator -= float(gained)
		add_gold(gained)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.passive_gold_ticked.emit(get_parent(), gained)
		return gained
	return 0

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

func is_hero_at_base() -> bool:
	if host_entity == null and get_parent() is BaseCombatEntity:
		host_entity = get_parent() as BaseCombatEntity
	if host_entity == null:
		return true
	var pos = host_entity.global_position if host_entity.is_inside_tree() else host_entity.position
	var base_pos = Vector3(-50.0, 0.5, 0.0) if host_entity.team == TeamDefinitions.Team.RADIANT else Vector3(50.0, 0.5, 0.0)
	return pos.distance_to(base_pos) <= 14.0

## Purchases and crafts an item, automatically taking owned recipe components into account
func buy_item(target_item: ItemResource, item_lookup_func: Callable = Callable()) -> bool:
	last_purchase_failure_reason = ""
	if target_item == null:
		last_purchase_failure_reason = "Geçersiz eşya."
		return false
		
	_ensure_slots()
	var solution = ItemTreeResolver.resolve_crafting(target_item, gold, slots, boots_slot, item_lookup_func)
	
	# Check courier space if away from base
	var at_base = is_hero_at_base()
	var courier: CharacterBody3D = null
	if host_entity != null:
		courier = CourierManagerClass.get_courier_for_team(host_entity.team)
		
	var courier_has_space = courier != null and is_instance_valid(courier) and courier.get_held_items_count() < 6
	var can_deliver_via_courier = (not at_base) and courier_has_space
	
	var has_space = solution.has_space or can_deliver_via_courier
	if not solution.can_afford:
		last_purchase_failure_reason = "Yetersiz altın (%d gerekli)." % solution.final_gold_cost
		return false
	if not has_space:
		last_purchase_failure_reason = "Envanter dolu%s." % (" ve kurye dolu" if not at_base else "")
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
		
	# Route: Courier vs Direct Equip
	if can_deliver_via_courier:
		courier.add_item_to_courier(target_item)
		courier.deliver_items_to(host_entity)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("EŞYA KURYE ÇANTASINA KOYULDU: %s -> KURYE SİZE DOĞRU YOLA ÇIKTI!" % target_item.item_name.to_upper())
	else:
		# Equip target item directly to hero
		if target_item.is_boots():
			if boots_slot == null:
				boots_slot = target_item
				_apply_stat_modifiers(target_item, "boots_slot")
				boots_slot_updated.emit(boots_slot)
			else:
				_place_in_first_free_slot(target_item)
		else:
			_place_in_first_free_slot(target_item)
		
	inventory_updated.emit()
	item_purchased.emit(target_item, solution.final_gold_cost)
	return true

var slot_purchase_times: Dictionary = {}
var boots_purchase_time: float = -100.0

func _place_in_first_free_slot(item: ItemResource) -> bool:
	_ensure_slots()
	for i in range(MAX_NORMAL_SLOTS):
		if slots[i] == null:
			slots[i] = item
			slot_purchase_times[i] = Time.get_ticks_msec() / 1000.0
			_apply_stat_modifiers(item, "slot_%d" % i)
			return true
	return false

func get_item_refund_value(slot_index: int) -> int:
	if slot_index < 0 or slot_index >= MAX_NORMAL_SLOTS:
		return 0
	var item = slots[slot_index]
	if item == null:
		return 0
	var now = Time.get_ticks_msec() / 1000.0
	var bought_at = slot_purchase_times.get(slot_index, -100.0)
	if (now - bought_at) <= 10.0:
		return item.cost
	return int(round(float(item.cost) * 0.50))

func is_item_in_full_refund_window(slot_index: int) -> bool:
	if slot_index < 0 or slot_index >= MAX_NORMAL_SLOTS or slots[slot_index] == null:
		return false
	var now = Time.get_ticks_msec() / 1000.0
	var bought_at = slot_purchase_times.get(slot_index, -100.0)
	return (now - bought_at) <= 10.0

func sell_item(slot_index: int) -> bool:
	_ensure_slots()
	if slot_index < 0 or slot_index >= MAX_NORMAL_SLOTS:
		return false
	var item = slots[slot_index]
	if item == null:
		return false
		
	var refund = get_item_refund_value(slot_index)
	slots[slot_index] = null
	slot_purchase_times.erase(slot_index)
	_remove_stat_modifiers("slot_%d" % slot_index)
	
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
	
	var now = Time.get_ticks_msec() / 1000.0
	var refund = item.cost if (now - boots_purchase_time) <= 10.0 else int(round(float(item.cost) * 0.50))
	boots_purchase_time = -100.0
	
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
		
	# Process Hybrid Conversions
	for tag in item.item_tags:
		match tag:
			"HYBRID_HP_TO_AD":
				var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
				var bonus_ad = max_hp * 0.02
				attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, bonus_ad, "item_hybrid_ad_" + slot_tag))
			"HYBRID_MANA_TO_AP":
				var max_mp = attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
				var bonus_ap = max_mp * 0.03
				attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ABILITY_POWER, StatModifier.Type.FLAT, bonus_ap, "item_hybrid_ap_" + slot_tag))
			"HYBRID_ARMOR_TO_REGEN":
				var armor = attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
				var bonus_regen = armor * 0.10
				attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.HEALTH_REGEN, StatModifier.Type.FLAT, bonus_regen, "item_hybrid_regen_" + slot_tag))

func _process(delta: float) -> void:
	if passive_gold_enabled and not unlimited_gold_mode:
		tick_passive_gold(delta)
		
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
		
	var parent_hero: BaseCombatEntity = host_entity
	if parent_hero == null and get_parent() is BaseCombatEntity:
		parent_hero = get_parent() as BaseCombatEntity
	elif parent_hero == null and attribute_system != null and attribute_system.get_parent() is BaseCombatEntity:
		parent_hero = attribute_system.get_parent() as BaseCombatEntity
		
	if parent_hero == null:
		return false
	if not _is_valid_active_target(item, parent_hero, target_entity, target_pos):
		return false
		
	# Check mana cost if applicable
	var mana_cost = 0.0
	if "mana_cost" in item:
		mana_cost = float(item.mana_cost)
	elif item.has_meta("mana_cost"):
		mana_cost = float(item.get_meta("mana_cost"))
		
	if mana_cost > 0.0 and parent_hero.attribute_system != null:
		if parent_hero.attribute_system.current_mana < mana_cost:
			return false
		parent_hero.attribute_system.current_mana -= mana_cost
		parent_hero.attribute_system.mana_changed.emit(parent_hero.attribute_system.current_mana, parent_hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA))
		
	var cd = item.active_cooldown if item.active_cooldown > 0.0 else 10.0
	var triggered = false
	
	if not item.active_action_tag.is_empty():
		triggered = ItemEventEngineClass.execute_active_item(parent_hero, item, target_entity, target_pos)
		cd = item.active_cooldown if item.active_cooldown > 0.0 else 15.0
	else:
		match item.id:
			114: # Lifebloom (Heal 300 HP)
				cd = 12.0
				var heal_target = target_entity if (target_entity != null and target_entity.team == parent_hero.team) else parent_hero
				var heal_val = 300.0 + (parent_hero.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) * 0.4)
				CombatMechanicsClass.heal(parent_hero, heal_target, heal_val, item.item_name)
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.combat_log_generated.emit("%s LIFEBLOOM KULLANDI (+%.0f CAN)" % [parent_hero.entity_name, heal_val])
				triggered = true
			115: # Radiant Aegis (Shield 350 HP for 4s)
				cd = 14.0
				var shield_target = target_entity if (target_entity != null and target_entity.team == parent_hero.team) else parent_hero
				if shield_target != null:
					CombatMechanicsClass.apply_shield(parent_hero, shield_target, "shield_radiant_aegis", item.item_name, 350.0, 4.0)
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.combat_log_generated.emit("%s RADIANT AEGIS KALKANI AÇTI (350 Kalkan)" % parent_hero.entity_name)
				triggered = true
			118: # Force Relic (Dash 6m)
				cd = 12.0
				var current_pos = parent_hero.global_position if parent_hero.is_inside_tree() else parent_hero.position
				var forward_dir = -parent_hero.transform.basis.z.normalized()
				if target_pos != Vector3.ZERO:
					forward_dir = (target_pos - current_pos).normalized()
					forward_dir.y = 0.0
				if parent_hero.is_inside_tree():
					parent_hero.global_position += forward_dir * 6.0
				else:
					parent_hero.position += forward_dir * 6.0
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
					var exec_result = CombatMechanicsClass.execute_missing_health_damage(parent_hero, enemy, 250.0, 0.20, "Executioner's Blade")
					var exec_dmg = exec_result.raw_damage
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
				triggered = true

	if triggered:
		slot_purchase_times.erase(slot_index)
		active_cooldowns[slot_index] = cd
		inventory_updated.emit()
		return true
		
	return false

## Shared aiming contract for item hotkeys, inventory clicks and bots.
func get_active_item_target_mode(slot_index: int) -> String:
	if slot_index < 0 or slot_index >= MAX_NORMAL_SLOTS:
		return "self"
	var item = slots[slot_index]
	if item == null:
		return "self"
	match item.active_action_tag:
		"ACTIVE_BLINK": return "ground"
		"ACTIVE_CYCLONE", "ACTIVE_HEX", "ACTIVE_EXECUTION", "ACTIVE_SILENCE": return "enemy"
		"ACTIVE_BARRIER", "ACTIVE_BURST_HEAL", "ACTIVE_HEAL": return "ally"
		"ACTIVE_FORCE_STAFF": return "unit"
	# Pre-tag catalogue actives.
	match item.id:
		74: return "enemy"
		114, 115: return "ally"
		118: return "ground"
	return "self"

func _is_valid_active_target(item: ItemResource, user: BaseCombatEntity, target_entity: BaseCombatEntity, target_pos: Vector3) -> bool:
	var mode := get_active_item_target_mode(slots.find(item))
	if mode == "ground":
		return target_pos != Vector3.ZERO
	if mode == "enemy":
		return target_entity != null and is_instance_valid(target_entity) and target_entity.team != user.team
	if mode == "ally":
		return target_entity != null and is_instance_valid(target_entity) and target_entity.team == user.team
	if mode == "unit":
		return target_entity != null and is_instance_valid(target_entity)
	return true

func _remove_stat_modifiers(slot_tag: String) -> void:
	_resolve_attribute_system()
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("item_" + slot_tag)
		attribute_system.remove_modifiers_by_source("item_hybrid_ad_" + slot_tag)
		attribute_system.remove_modifiers_by_source("item_hybrid_ap_" + slot_tag)
		attribute_system.remove_modifiers_by_source("item_hybrid_regen_" + slot_tag)

func equip_item(item: ItemResource, slot_idx: int = -1) -> bool:
	if item == null:
		return false
	_ensure_slots()
	if item.is_boots():
		if boots_slot != null:
			_remove_stat_modifiers("boots_slot")
		boots_slot = item
		_apply_stat_modifiers(item, "boots_slot")
		boots_slot_updated.emit(boots_slot)
		inventory_updated.emit()
		return true
	
	if slot_idx >= 0 and slot_idx < MAX_NORMAL_SLOTS:
		if slots[slot_idx] != null:
			_remove_stat_modifiers("slot_%d" % slot_idx)
		slots[slot_idx] = item
		_apply_stat_modifiers(item, "slot_%d" % slot_idx)
		inventory_updated.emit()
		return true
	else:
		return _place_in_first_free_slot(item)

func unequip_item(slot_idx: int) -> ItemResource:
	_ensure_slots()
	if slot_idx < 0 or slot_idx >= MAX_NORMAL_SLOTS:
		return null
	var item = slots[slot_idx]
	if item != null:
		slots[slot_idx] = null
		_remove_stat_modifiers("slot_%d" % slot_idx)
		inventory_updated.emit()
	return item

## Swaps items between two slot indices (0-5) or between normal slot and boots slot (6 or -1)
func swap_slots(from_idx: int, to_idx: int) -> bool:
	_ensure_slots()
	if from_idx == to_idx:
		return true
		
	# Handle Boots Slot Swap
	if from_idx == 6 or from_idx == -1: # From Boots
		if to_idx < 0 or to_idx >= MAX_NORMAL_SLOTS:
			return false
		var to_item = slots[to_idx]
		if to_item != null and not to_item.is_boots():
			return false # Only boots can go into boots slot
		var old_boot = boots_slot
		_remove_stat_modifiers("boots_slot")
		_remove_stat_modifiers("slot_%d" % to_idx)
		boots_slot = to_item
		slots[to_idx] = old_boot
		if boots_slot != null: _apply_stat_modifiers(boots_slot, "boots_slot")
		if slots[to_idx] != null: _apply_stat_modifiers(slots[to_idx], "slot_%d" % to_idx)
		boots_slot_updated.emit(boots_slot)
		inventory_updated.emit()
		return true
		
	if to_idx == 6 or to_idx == -1: # To Boots
		if from_idx < 0 or from_idx >= MAX_NORMAL_SLOTS:
			return false
		var from_item = slots[from_idx]
		if from_item != null and not from_item.is_boots():
			return false # Only boots can go into boots slot
		var old_boot = boots_slot
		_remove_stat_modifiers("boots_slot")
		_remove_stat_modifiers("slot_%d" % from_idx)
		boots_slot = from_item
		slots[from_idx] = old_boot
		if boots_slot != null: _apply_stat_modifiers(boots_slot, "boots_slot")
		if slots[from_idx] != null: _apply_stat_modifiers(slots[from_idx], "slot_%d" % from_idx)
		boots_slot_updated.emit(boots_slot)
		inventory_updated.emit()
		return true

	# Normal 0-5 Swap
	if from_idx < 0 or from_idx >= MAX_NORMAL_SLOTS or to_idx < 0 or to_idx >= MAX_NORMAL_SLOTS:
		return false
		
	var item_a = slots[from_idx]
	var item_b = slots[to_idx]
	
	_remove_stat_modifiers("slot_%d" % from_idx)
	_remove_stat_modifiers("slot_%d" % to_idx)
	
	slots[from_idx] = item_b
	slots[to_idx] = item_a
	
	if slots[from_idx] != null:
		_apply_stat_modifiers(slots[from_idx], "slot_%d" % from_idx)
	if slots[to_idx] != null:
		_apply_stat_modifiers(slots[to_idx], "slot_%d" % to_idx)
		
	# Swap cooldown tracking if any
	var cd_a = active_cooldowns.get(from_idx, 0.0)
	var cd_b = active_cooldowns.get(to_idx, 0.0)
	active_cooldowns[from_idx] = cd_b
	active_cooldowns[to_idx] = cd_a
	
	inventory_updated.emit()
	return true

## Drops an item from the specified slot into the 3D world as an ItemPickup3D
func drop_item_to_world(slot_idx: int, drop_pos: Vector3 = Vector3.ZERO) -> Node3D:
	_ensure_slots()
	var item: ItemResource = null
	if slot_idx == 6 or slot_idx == -1:
		item = boots_slot
		boots_slot = null
		_remove_stat_modifiers("boots_slot")
		boots_slot_updated.emit(null)
	elif slot_idx >= 0 and slot_idx < MAX_NORMAL_SLOTS:
		item = slots[slot_idx]
		slots[slot_idx] = null
		_remove_stat_modifiers("slot_%d" % slot_idx)
		active_cooldowns.erase(slot_idx)
		
	if item == null:
		return null
		
	inventory_updated.emit()
	
	var world_root: Node = (get_tree().current_scene if (is_inside_tree() and get_tree() != null) else null)
	if world_root == null and host_entity != null and host_entity.is_inside_tree():
		world_root = host_entity.get_parent()
		
	var p_pos = drop_pos
	if p_pos == Vector3.ZERO and host_entity != null:
		p_pos = (host_entity.global_position if host_entity.is_inside_tree() else host_entity.position) + Vector3(randf_range(-1.0, 1.0), 0.2, randf_range(-1.0, 1.0))
		
	var pickup = ItemPickup3DClass.new()
	pickup.init_item(item, p_pos)
	if world_root != null:
		world_root.add_child(pickup)
		pickup.global_position = p_pos
		
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("EŞYA YERE BIRAKILDI: %s" % item.item_name.to_upper())
		
	return pickup

func get_item_in_slot(slot_idx: int) -> ItemResource:
	_ensure_slots()
	if slot_idx < 0 or slot_idx >= MAX_NORMAL_SLOTS:
		return null
	return slots[slot_idx]

func get_all_equipped_items() -> Array[ItemResource]:
	_ensure_slots()
	var list: Array[ItemResource] = []
	for s in slots:
		if s != null:
			list.append(s)
	if boots_slot != null:
		list.append(boots_slot)
	return list

func has_item(item_id: int) -> bool:
	_ensure_slots()
	for s in slots:
		if s != null and s.id == item_id:
			return true
	if boots_slot != null and boots_slot.id == item_id:
		return true
	return false

func has_item_by_name(item_name: String) -> bool:
	_ensure_slots()
	var lower = item_name.to_lower()
	for s in slots:
		if s != null and s.item_name.to_lower() == lower:
			return true
	if boots_slot != null and boots_slot.item_name.to_lower() == lower:
		return true
	return false

func get_total_stat_bonus(target_stat: StatModifier.TargetStat) -> float:
	var total = 0.0
	for item in get_all_equipped_items():
		if item != null and item.stat_bonuses.has(target_stat):
			total += float(item.stat_bonuses[target_stat])
	return total
