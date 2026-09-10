class_name HeroSkillRouter
extends RefCounted

## Routes player input to a hero's bespoke cast function when it has one.
## The route list is intentionally explicit: unusual two-stage skills remain
## on AbilityContainer until their targeting flow is implemented properly.

enum InputKind { TARGET, POINT, SELF }

const ROUTES := {
	"mordren": [InputKind.TARGET, InputKind.SELF, InputKind.SELF, InputKind.TARGET],
	"nyxara": [InputKind.TARGET, InputKind.TARGET, InputKind.TARGET, InputKind.SELF],
	"selka": [InputKind.TARGET, InputKind.POINT, InputKind.SELF, InputKind.SELF],
	"talon": [InputKind.TARGET, InputKind.SELF, InputKind.SELF, InputKind.SELF],
	"noctis": [InputKind.TARGET, InputKind.SELF, InputKind.TARGET, InputKind.POINT],
	"grom": [InputKind.TARGET, InputKind.SELF, InputKind.POINT, InputKind.TARGET],
	"gorak": [InputKind.TARGET, InputKind.TARGET, InputKind.SELF, InputKind.TARGET],
	"sera": [InputKind.TARGET, InputKind.TARGET, InputKind.TARGET, InputKind.SELF],
	"nixe": [InputKind.POINT, InputKind.POINT, InputKind.SELF, InputKind.TARGET],
	"geras": [InputKind.POINT, InputKind.POINT, InputKind.POINT, InputKind.POINT],
	"zin": [InputKind.POINT, InputKind.SELF, InputKind.SELF, InputKind.POINT],
	"nymera": [InputKind.POINT, InputKind.TARGET, InputKind.TARGET, InputKind.POINT],
	"aethon": [InputKind.POINT, InputKind.POINT, InputKind.SELF, InputKind.POINT],
	"aria": [InputKind.POINT, InputKind.SELF, InputKind.TARGET, InputKind.TARGET],
	"astran": [InputKind.POINT, InputKind.SELF, InputKind.POINT, InputKind.POINT],
	"astris": [InputKind.TARGET, InputKind.POINT, InputKind.SELF, InputKind.POINT],
	"aurik": [InputKind.POINT, InputKind.POINT, InputKind.POINT, InputKind.POINT],
	"drogas": [InputKind.POINT, InputKind.SELF, InputKind.POINT, InputKind.POINT],
	"elarion": [InputKind.POINT, InputKind.TARGET, InputKind.TARGET, InputKind.SELF],
	"elyra": [InputKind.SELF, InputKind.SELF, InputKind.TARGET, InputKind.SELF],
	"veylin": [InputKind.TARGET, InputKind.SELF, InputKind.SELF, InputKind.POINT],
	"ravena": [InputKind.TARGET, InputKind.POINT, InputKind.TARGET, InputKind.TARGET],
	"zarek": [InputKind.TARGET, InputKind.TARGET, InputKind.TARGET, InputKind.POINT],
	"ilyra": [InputKind.TARGET, InputKind.POINT, InputKind.TARGET, InputKind.POINT],
	"seris": [InputKind.TARGET, InputKind.POINT, InputKind.SELF, InputKind.POINT],
	"rivena": [InputKind.TARGET, InputKind.POINT, InputKind.TARGET, InputKind.SELF],
	"lyra": [InputKind.TARGET, InputKind.SELF, InputKind.SELF, InputKind.POINT],
	"oryn": [InputKind.TARGET, InputKind.TARGET, InputKind.TARGET, InputKind.TARGET],
	"auron": [InputKind.TARGET, InputKind.TARGET, InputKind.SELF, InputKind.TARGET],
	"brakka": [InputKind.TARGET, InputKind.SELF, InputKind.TARGET, InputKind.SELF],
	"tharos": [InputKind.SELF, InputKind.SELF, InputKind.POINT, InputKind.SELF],
	"durn": [InputKind.POINT, InputKind.SELF, InputKind.POINT, InputKind.POINT],
	"kharos": [InputKind.TARGET, InputKind.SELF, InputKind.TARGET, InputKind.SELF],
	"kaeli": [InputKind.TARGET, InputKind.SELF, InputKind.SELF, InputKind.SELF],
	"kaelen": [InputKind.POINT, InputKind.TARGET, InputKind.SELF, InputKind.SELF],
	"kaelgor": [InputKind.TARGET, InputKind.SELF, InputKind.SELF, InputKind.SELF],
	"varyn": [InputKind.TARGET, InputKind.SELF, InputKind.SELF, InputKind.SELF],
	"aurelian": [InputKind.TARGET, InputKind.TARGET, InputKind.SELF, InputKind.TARGET],
	"malakor": [InputKind.POINT, InputKind.SELF, InputKind.TARGET, InputKind.POINT],
	"malthus": [InputKind.POINT, InputKind.SELF, InputKind.SELF, InputKind.TARGET],
	"mira": [InputKind.TARGET, InputKind.SELF, InputKind.SELF, InputKind.SELF],
	"mora": [InputKind.TARGET, InputKind.TARGET, InputKind.TARGET, InputKind.SELF],
	"morven": [InputKind.TARGET, InputKind.POINT, InputKind.TARGET, InputKind.TARGET],
	"neris": [InputKind.POINT, InputKind.SELF, InputKind.POINT, InputKind.POINT],
	"okar": [InputKind.POINT, InputKind.SELF, InputKind.SELF, InputKind.POINT],
	"solen": [InputKind.POINT, InputKind.SELF, InputKind.SELF, InputKind.POINT],
	"trak": [InputKind.POINT, InputKind.SELF, InputKind.POINT, InputKind.SELF],
	"vael": [InputKind.TARGET, InputKind.TARGET, InputKind.SELF, InputKind.POINT],
	"valerius": [InputKind.TARGET, InputKind.POINT, InputKind.TARGET, InputKind.POINT],
	"valgor": [InputKind.POINT, InputKind.POINT, InputKind.SELF, InputKind.SELF],
	"velum": [InputKind.POINT, InputKind.TARGET, InputKind.TARGET, InputKind.TARGET],
	"veyra": [InputKind.TARGET, InputKind.SELF, InputKind.SELF, InputKind.POINT],
	"vulkor": [InputKind.TARGET, InputKind.POINT, InputKind.SELF, InputKind.POINT],
	"xerana": [InputKind.POINT, InputKind.POINT, InputKind.TARGET, InputKind.SELF],
	"zyraen": [InputKind.TARGET, InputKind.TARGET, InputKind.SELF, InputKind.SELF]
}

static func try_cast(hero: HeroEntity, slot: AbilityResource.Slot, target: BaseCombatEntity, point: Vector3) -> bool:
	if hero == null or hero.hero_resource == null or hero.ability_container == null:
		return false
	var h_id = hero.hero_resource.hero_id.to_lower()
	if not ROUTES.has(h_id) and "id" in hero.hero_resource and ROUTES.has(str(hero.hero_resource.id).to_lower()):
		h_id = str(hero.hero_resource.id).to_lower()
	elif not ROUTES.has(h_id) and "entity_name" in hero and ROUTES.has(str(hero.entity_name).to_lower()):
		h_id = str(hero.entity_name).to_lower()
	var route = ROUTES.get(h_id, null)
	var slot_index := _combat_slot_index(slot)
	if route == null or slot_index < 0 or slot_index >= route.size():
		return false
	var key = ["q", "w", "e", "r"][slot_index]
	var method = "cast_%s_%s" % [h_id, key]
	if not hero.has_method(method):
		return false
	var kind: InputKind = route[slot_index]
	if kind == InputKind.TARGET and (target == null or not is_instance_valid(target)):
		return false
	# Validate before a bespoke function runs. Some older hero functions own all
	# their damage logic and do not call AbilityContainer themselves.
	var can_cast := false
	match kind:
		InputKind.TARGET:
			can_cast = hero.ability_container.can_cast_on_target(slot, target)
		InputKind.POINT:
			can_cast = hero.ability_container.can_cast_on_target(slot, null, point)
		InputKind.SELF:
			can_cast = hero.ability_container.can_cast(slot)
	if not can_cast:
		return false
	# Bespoke functions call AbilityContainer themselves. This flag makes that
	# call pay its normal cost without adding generic damage a second time.
	hero.ability_container.next_cast_is_custom = true
	var outcome: Variant
	match kind:
		InputKind.TARGET:
			outcome = hero.call(method, target)
		InputKind.POINT:
			outcome = hero.call(method, point)
		InputKind.SELF:
			outcome = hero.call(method)
	if outcome == null or (outcome is bool and not outcome):
		hero.ability_container.next_cast_is_custom = false
		return false
	# A bespoke function that did not call the container still needs to spend
	# mana/start cooldown. The pending custom flag ensures no generic damage is
	# added during this bookkeeping cast.
	if hero.ability_container.next_cast_is_custom:
		hero.ability_container.cast_ability(slot, target if kind == InputKind.TARGET else null, point if kind == InputKind.POINT else Vector3.ZERO)
	return true

static func _combat_slot_index(slot: AbilityResource.Slot) -> int:
	match slot:
		AbilityResource.Slot.Q: return 0
		AbilityResource.Slot.W: return 1
		AbilityResource.Slot.E: return 2
		AbilityResource.Slot.R: return 3
		_: return -1

static func try_cast_two_point(hero: HeroEntity, slot: AbilityResource.Slot, first_point: Vector3, second_point: Vector3) -> bool:
	if hero == null or hero.hero_resource == null or hero.ability_container == null:
		return false
	if hero.hero_resource.hero_id.to_lower() != "neris" or slot not in [AbilityResource.Slot.Q, AbilityResource.Slot.E]:
		return false
	if not hero.ability_container.can_cast_on_target(slot, null, second_point):
		return false
	var suffix = "q" if slot == AbilityResource.Slot.Q else "e"
	var method = "cast_neris_%s" % suffix
	if not hero.has_method(method):
		return false
	hero.ability_container.next_cast_is_custom = true
	var outcome = hero.call(method, first_point, second_point)
	if outcome == null or (outcome is bool and not outcome):
		hero.ability_container.next_cast_is_custom = false
		return false
	if hero.ability_container.next_cast_is_custom:
		hero.ability_container.cast_ability(slot, null, second_point)
	return true
