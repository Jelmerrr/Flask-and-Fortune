extends HBoxContainer

@onready var background_texture: TextureRect = $"Background Texture"
@onready var item_icon: TextureRect = $"Background Texture/Item Icon"
@onready var item_name: Label = $"Item Name"

@export var itemEntry: ItemResource

var backTextureUnselected = preload("uid://44kn2n173jqa")
var backTextureSelected = preload("uid://b1wsvdvgrtcy3")
var isActive: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.gainKnowledgeOfItem.connect(revealItem)
	GlobalSignalBus.switchCompendiumPage.connect(updateBackgroundElement)
	updateUIElement(itemEntry)

func revealItem(item: ItemResource):
	if item == itemEntry:
		updateUIElement(itemEntry)

func updateUIElement(itemEntry: ItemResource):
	if itemEntry.playerHasKnowledgeOfItem:
		item_icon.texture = itemEntry.itemTexture
		item_name.text = itemEntry.itemName
		isActive = true
	else:
		item_icon.texture = itemEntry.itemTextureUnrevealed
		item_name.text = "? ? ?"

func updateBackgroundElement(node: Node):
	if node == self:
		background_texture.texture = backTextureSelected
	else:
		background_texture.texture = backTextureUnselected

func _on_selection_button_pressed() -> void:
	if isActive:
		GlobalSignalBus.updateCompendiumRightPageText.emit(itemEntry)
		GlobalSignalBus.switchCompendiumPage.emit(self)
