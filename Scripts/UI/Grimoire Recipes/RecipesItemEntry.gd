extends HBoxContainer

@onready var background_texture: TextureRect = $"Background Texture"
@onready var item_icon: TextureRect = $"Background Texture/Item Icon"
@onready var item_name: Label = $"Item Name"

var backTextureUnselected = preload("uid://44kn2n173jqa")
var backTextureSelected = preload("uid://b1wsvdvgrtcy3")

@export var craftingRecipeEntry: CraftingRecipe

var isActive: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateUIElement(craftingRecipeEntry)
	GlobalSignalBus.switchSelectedRecipe.connect(updateBackgroundElement)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func updateUIElement(craftingRecipeEntry: CraftingRecipe):
	craftingRecipeEntry.hasKnowledgeOfIngredients = checkIngredientsKnowledge(craftingRecipeEntry)
	if craftingRecipeEntry.hasKnowledgeOfIngredients:
		item_icon.texture = craftingRecipeEntry.results.mainResults.lootTable[0].Item.itemTextureUnrevealed
		item_name.text = "? ? ?"
		isActive = true
	if craftingRecipeEntry.hasKnowledgeOfFullRecipe:
		item_icon.texture = craftingRecipeEntry.results.mainResults.lootTable[0].Item.itemTexture
		item_name.text = craftingRecipeEntry.results.mainResults.lootTable[0].Item.itemName
		isActive = true
	if !craftingRecipeEntry.hasKnowledgeOfIngredients and !craftingRecipeEntry.hasKnowledgeOfFullRecipe:
		self.queue_free()

func checkIngredientsKnowledge(craftingRecipeEntry: CraftingRecipe) -> bool:
	for ingredient in craftingRecipeEntry.ingredients:
		if ingredient.item.playerHasKnowledgeOfItem:
			return true
	return false

func updateBackgroundElement(node: Node):
	if node == self:
		background_texture.texture = backTextureSelected
	else:
		background_texture.texture = backTextureUnselected

func _on_selection_button_pressed() -> void:
	if isActive:
		print("yay")
		GlobalSignalBus.updateRecipeRightPage.emit(craftingRecipeEntry)
		GlobalSignalBus.switchSelectedRecipe.emit(self)
