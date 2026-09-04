extends MarginContainer

@onready var item_entry_vbox: VBoxContainer = $"HBoxContainer/LeftPage/LeftMargin/GlobalPageVbox/Compendium item master container/CategoryAndItems Vbox/ScrollContainer/Item Entry Vbox"
@onready var collection_log: Label = $"HBoxContainer/LeftPage/LeftMargin/GlobalPageVbox/Bottom Area/Collection Log"

@onready var item_name: Label = $"HBoxContainer/RightPage/RightMargin/VBoxContainer/Item Name"
@onready var item_description: Label = $"HBoxContainer/RightPage/RightMargin/VBoxContainer/Item Description"
@onready var item_texture: TextureRect = $"HBoxContainer/RightPage/RightMargin/VBoxContainer/VBoxContainer/HBoxContainer/Item Texture"


var baseLogColor: Color = Color("7d6661")
var completedLogColor: Color = Color("617062")

var itemEntrySceneRef = preload("uid://btltdlmdm271c")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.gainKnowledgeOfItem.connect(updateCollectionLog)
	GlobalSignalBus.updateCompendiumRightPageText.connect(updateRightPage)
	updateCollectionLog()
	for item in GlobalItemDatabase.itemDatabase:
		var instance = itemEntrySceneRef.instantiate()
		instance.itemEntry = item
		item_entry_vbox.add_child.call_deferred(instance)

func updateCollectionLog(_itemResource: ItemResource = null):
	var itemTotal: int = GlobalItemDatabase.itemDatabase.size()
	var collectedTotal: int = 0
	for item in GlobalItemDatabase.itemDatabase:
		if item.playerHasKnowledgeOfItem:
			collectedTotal += 1
	collection_log.text = "Collection log: " + str(collectedTotal) + " / " + str(itemTotal)
	if collectedTotal == itemTotal:
		collection_log.add_theme_color_override("font_color", completedLogColor)
	else:
		collection_log.remove_theme_color_override("font_color")

func updateRightPage(item: ItemResource):
	if item.playerHasKnowledgeOfItem:
		item_name.text = item.itemName
		item_description.text = item.itemDescription
		item_texture.texture = item.itemTexture
		AudioController.playEvent(preload("uid://4ap0gofrn21a"))
