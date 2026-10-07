extends HBoxContainer

@onready var slot_1_texture: TextureRect = $"Slot 1/Slot 1 Texture"
@onready var slot_2_texture: TextureRect = $"Slot 2/Slot 2 Texture"
@onready var slot_3_texture: TextureRect = $"Slot 3/Slot 3 Texture"
@onready var slot_4_texture: TextureRect = $"Slot 4/Slot 4 Texture"
@onready var slot_5_texture: TextureRect = $"Slot 5/Slot 5 Texture"

@onready var slot_1_item_texture: TextureRect = $"Slot 1/Slot 1 Texture/ItemMargin/Slot1ItemTexture"
@onready var slot_1_amount: Label = $"Slot 1/Slot 1 Texture/ItemMargin/Slot1Amount"
@onready var slot_2_item_texture: TextureRect = $"Slot 2/Slot 2 Texture/ItemMargin/Slot2ItemTexture"
@onready var slot_2_amount: Label = $"Slot 2/Slot 2 Texture/ItemMargin/Slot2Amount"
@onready var slot_3_item_texture: TextureRect = $"Slot 3/Slot 3 Texture/ItemMargin/Slot3ItemTexture"
@onready var slot_3_amount: Label = $"Slot 3/Slot 3 Texture/ItemMargin/Slot3Amount"
@onready var slot_4_item_texture: TextureRect = $"Slot 4/Slot 4 Texture/ItemMargin/Slot4ItemTexture"
@onready var slot_4_amount: Label = $"Slot 4/Slot 4 Texture/ItemMargin/Slot4Amount"
@onready var slot_5_item_texture: TextureRect = $"Slot 5/Slot 5 Texture/ItemMargin/Slot5ItemTexture"
@onready var slot_5_amount: Label = $"Slot 5/Slot 5 Texture/ItemMargin/Slot5Amount"


const ITEM_HUD_SELECTED = preload("uid://74micjteu2j6")
const ITEM_HUD_UNSELECTED = preload("uid://b5ukmk0ou1mcc")


@onready var slotArray: Array[TextureRect] = [slot_1_texture, slot_2_texture, slot_3_texture, slot_4_texture, slot_5_texture]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateVisuals()
	GlobalSignalBus.changeSelectedHotbarSlotUI.connect(updateVisuals)
	GlobalSignalBus.updateInventoryHotbar.connect(updateItemInfo)

func updateVisuals() -> void:
	for slot in slotArray:
		if slot == slotArray[UtilsGlobalVariables.currentPlayerSelectedHotbarSlot]:
			slot.texture = ITEM_HUD_SELECTED
		else:
			slot.texture = ITEM_HUD_UNSELECTED

func updateItemInfo() -> void:
	var playerInventoryRef: Inventory = UtilsGlobalVariables.playerDataRef.inventoryRef
	if playerInventoryRef.inventory[0].item != null:
		slot_1_item_texture.texture = playerInventoryRef.inventory[0].item.itemTexture
		slot_1_amount.text = str(playerInventoryRef.inventory[0].amount)
	elif playerInventoryRef.inventory[0].item == null:
		slot_1_item_texture.texture = null
		slot_1_amount.text = ""
	if playerInventoryRef.inventory[1].item != null:
		slot_2_item_texture.texture = playerInventoryRef.inventory[1].item.itemTexture
		slot_2_amount.text = str(playerInventoryRef.inventory[1].amount)
	elif playerInventoryRef.inventory[1].item == null:
		slot_2_item_texture.texture = null
		slot_2_amount.text = ""
	if playerInventoryRef.inventory[2].item != null:
		slot_3_item_texture.texture = playerInventoryRef.inventory[2].item.itemTexture
		slot_3_amount.text = str(playerInventoryRef.inventory[2].amount)
	elif playerInventoryRef.inventory[2].item == null:
		slot_3_item_texture.texture = null
		slot_3_amount.text = ""
	if playerInventoryRef.inventory[3].item != null:
		slot_4_item_texture.texture = playerInventoryRef.inventory[3].item.itemTexture
		slot_4_amount.text = str(playerInventoryRef.inventory[3].amount)
	elif playerInventoryRef.inventory[3].item == null:
		slot_4_item_texture.texture = null
		slot_4_amount.text = ""
	if playerInventoryRef.inventory[4].item != null:
		slot_5_item_texture.texture = playerInventoryRef.inventory[4].item.itemTexture
		slot_5_amount.text = str(playerInventoryRef.inventory[4].amount)
	elif playerInventoryRef.inventory[4].item == null:
		slot_5_item_texture.texture = null
		slot_5_amount.text = ""

func _physics_process(_delta: float) -> void:
	#I want to do this cleaner but for some reason I can't get match statements to work with inputEvent shrug
	pass
	#for i in range(5):
		#if Input.is_action_just_pressed("HotbarSlot" + str(i+1)):
			#UtilsGlobalVariables.currentPlayerSelectedHotbarSlot = i

func _unhandled_input(event: InputEvent) -> void:
	if event == InputEventKey:
		print(event)
	for i in range(5):
		if Input.is_action_just_pressed("HotbarSlot" + str(i+1)):
			UtilsGlobalVariables.currentPlayerSelectedHotbarSlot = i
			get_viewport().set_input_as_handled()
