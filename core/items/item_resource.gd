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

func is_boots() -> bool:
	return category == Category.BOOTS

func is_recipe() -> bool:
	return recipe_components.size() > 0
