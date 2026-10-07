extends TextureRect


@export var inventorySlotUUID: int
@onready var item_icon: TextureRect = $"MarginContainer/Item Icon"
@onready var item_amount_label: Label = $MarginContainer/ItemAmountLabel

func _ready() -> void:
	GlobalSignalBus.updateInventoryUI.connect(updateInventorySlot)

# Called when the node enters the scene tree for the first time.
func updateInventorySlot() -> void:
	if UtilsGlobalVariables.playerDataRef.inventoryRef.inventory[inventorySlotUUID].item != null:
		item_icon.texture = UtilsGlobalVariables.playerDataRef.inventoryRef.inventory[inventorySlotUUID].item.itemTexture
		item_amount_label.text = str(UtilsGlobalVariables.playerDataRef.inventoryRef.inventory[inventorySlotUUID].amount)
	else:
		item_icon.texture = null
		item_amount_label.text = ""

func _on_inventory_slot_button_pressed() -> void:
	GlobalSignalBus.inventorySlotPressed.emit(inventorySlotUUID, false)
