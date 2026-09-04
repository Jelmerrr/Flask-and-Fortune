extends MarginContainer

@onready var item_name: Label = $"HBoxContainer/RightPage/RightMargin/VBoxContainer/Item Name"
@onready var item_description: Label = $"HBoxContainer/RightPage/RightMargin/VBoxContainer/Item Description"
@onready var item_texture: TextureRect = $"HBoxContainer/RightPage/RightMargin/VBoxContainer/VBoxContainer/HBoxContainer/Item Texture"

func updateLeftPageInfo(item: ItemResource):
	pass
	#item_name.text = item.itemName
	#item_description.text = item.itemDescription
	#item_texture.texture = item.itemTexture
