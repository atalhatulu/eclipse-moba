class_name ItemTreeResolver
extends RefCounted

## Resolves hierarchical item recipes, dependency trees, and partial inventory discounts

class CraftingSolution:
	var target_item: ItemResource
	var final_gold_cost: int = 0
	var components_owned_value: int = 0
	var normal_slots_to_consume: Array[int] = []
	var consumes_boots_slot: bool = false
	var can_afford: bool = false
	var has_space: bool = false

## Analyzes the player inventory against an item's recipe tree
static func resolve_crafting(
	target_item: ItemResource,
	current_gold: int,
	inventory_slots: Array[ItemResource],
	current_boots: ItemResource,
	_item_lookup_func: Callable = Callable()
) -> CraftingSolution:
	var solution = CraftingSolution.new()
	solution.target_item = target_item
	
	if target_item == null:
		return solution
		
	var needed_component_ids = target_item.recipe_components.duplicate()
	var discount = 0
	
	# Check boots slot first if target is upgraded boots
	if target_item.is_boots() and current_boots != null:
		var found_idx = needed_component_ids.find(current_boots.id)
		if found_idx != -1:
			needed_component_ids.remove_at(found_idx)
			discount += current_boots.cost
			solution.consumes_boots_slot = true
			
	# Check normal inventory slots for remaining components
	for slot_idx in range(inventory_slots.size()):
		var item_in_slot = inventory_slots[slot_idx]
		if item_in_slot != null:
			var comp_idx = needed_component_ids.find(item_in_slot.id)
			if comp_idx != -1:
				needed_component_ids.remove_at(comp_idx)
				discount += item_in_slot.cost
				solution.normal_slots_to_consume.append(slot_idx)
				
	# If there are still missing components, their cost is included in full price
	solution.components_owned_value = discount
	solution.final_gold_cost = maxi(0, target_item.cost - discount)
	solution.can_afford = current_gold >= solution.final_gold_cost
	
	# Determine if there is inventory space
	# Consumed slots free up space.
	var freed_slots = solution.normal_slots_to_consume.size()
	var empty_slots = 0
	for it in inventory_slots:
		if it == null:
			empty_slots += 1
			
	if target_item.is_boots():
		# Goes to boots slot if empty or upgrading
		solution.has_space = (current_boots == null or solution.consumes_boots_slot or (empty_slots + freed_slots) > 0)
	else:
		# Requires at least 1 net slot
		solution.has_space = (empty_slots + freed_slots) > 0 or freed_slots > 0
		
	return solution
