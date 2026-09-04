extends HBoxContainer

@onready var background_texture: TextureRect = $"Background Texture"
@onready var item_icon: TextureRect = $"Background Texture/Item Icon"
@onready var item_name: Label = $"Item Name"

@export var itemEntry: ItemResource

var backTextureUnselected = preload("uid://44kn2n173jqa")
var backTextureSelected = preload("uid://b1wsvdvgrtcy3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.gainKnowledgeOfItem.connect(revealItem)
	updateUIElement(itemEntry)

func revealItem(item: ItemResource):
	if item == itemEntry:
		updateUIElement(itemEntry)

func updateUIElement(itemEntry: ItemResource):
	if itemEntry.playerHasKnowledgeOfItem:
		item_icon.texture = itemEntry.itemTexture
		item_name.text = itemEntry.itemName
	else:
		item_icon.texture = itemEntry.itemTextureUnrevealed
		item_name.text = "? ? ?"


func _on_selection_button_pressed() -> void:
	GlobalSignalBus.updateCompendiumRightPageText.emit(itemEntry)
