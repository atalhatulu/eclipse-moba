class_name ItemResource
extends Resource

## Data definition for items in Eclipse Front

enum Category {
	BASE,
	BOOTS,
	INTERMEDIATE,
	LEGENDARY,
	SUPPORT
}

@export var id: int = 1
@export var item_name: String = "Item"
@export var category: Category = Category.BASE
@export var cost: int = 350
@export var description: String = ""
@export var stat_bonuses: Dictionary = {} # StatModifier.TargetStat -> float
@export var recipe_components: Array[int] = [] # IDs of sub-items
@export var build_path_role: String = ""
@export var icon_path: String = ""

@export_group("Active & Passive Tags")
@export var active_name: String = ""
@export var active_action_tag: String = ""
@export var active_cooldown: float = 0.0
@export var item_tags: Array[String] = []

func is_boots() -> bool:
	return category == Category.BOOTS

func is_recipe() -> bool:
	return recipe_components.size() > 0

func has_active() -> bool:
	return not active_action_tag.is_empty() and active_cooldown > 0.0
