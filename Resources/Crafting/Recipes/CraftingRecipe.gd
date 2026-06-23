extends Resource

class_name CraftingRecipe

@export var ingredients: Array[InventorySlot]
@export var results: CraftingRecipeResult
@export var method: CraftingMethods
@export var station: CraftingStations
@export var craftingTime: float
@export var recipeName: String
