extends MarginContainer

const itemEntrySceneRef = preload("uid://cs6hfuc4jo5qs")

@onready var recipe_entry_vbox: VBoxContainer = $"HBoxContainer/LeftPage/LeftMargin/GlobalPageVbox/RecipeItemContainer/RecipeListContainer/ScrollContainer/Recipe Entry Vbox"

var foundRecipes: Array[CraftingRecipe]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.updateRecipeBook.connect(setupRecipes)
	GlobalSignalBus.updateRecipeRightPage.connect(updateSelectedRecipeInfoRightPage)
	loadAllRecipes()

func loadAllRecipes() -> void:
	foundRecipes.clear()
	#Replace "Alchemy" with appropriate creafting method when making new methods
	for file in DirAccess.get_files_at("res://Resources/Crafting/Recipes/Resource Files/Alchemy/"):
		foundRecipes.append(ResourceLoader.load("res://Resources/Crafting/Recipes/Resource Files/Alchemy/"+file))

func setupRecipes() -> void:
	for child in recipe_entry_vbox.get_children():
		child.queue_free()
	loadAllRecipes()
	for recipe in foundRecipes:
		var instance = itemEntrySceneRef.instantiate()
		instance.craftingRecipeEntry = recipe
		recipe_entry_vbox.add_child.call_deferred(instance)

func updateSelectedRecipeInfoRightPage():
	pass
