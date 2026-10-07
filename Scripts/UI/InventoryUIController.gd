extends MarginContainer

@onready var weight_bar: ProgressBar = $"HBoxContainer/LeftPage/LeftMargin/Weight Vbox/WeightBar"
@onready var weight_label: Label = $"HBoxContainer/LeftPage/LeftMargin/Weight Vbox/WeightLabel"

var mouseOffset: Vector2
var visualNode: Node = null
var clickedNode: Node = null
var grabbedItemOriginalNode: Node = null
var grabbedItemOriginalUUID: int

const GRIMOIRE_INVENTORY_ITEM_SLOT = preload("uid://ck0ba3v6djyk4")

@onready var inventory_row_1: HBoxContainer = $"HBoxContainer/LeftPage/LeftMargin/InventoryVbox/Item Slots/Inventory Row"
@onready var inventory_row_2: HBoxContainer = $"HBoxContainer/LeftPage/LeftMargin/InventoryVbox/Item Slots/Inventory Row2"
@onready var inventory_row_3: HBoxContainer = $"HBoxContainer/LeftPage/LeftMargin/InventoryVbox/Item Slots/Inventory Row3"
@onready var inventory_row_4: HBoxContainer = $"HBoxContainer/LeftPage/LeftMargin/InventoryVbox/Item Slots/Inventory Row4"
@onready var inventory_row_5: HBoxContainer = $"HBoxContainer/LeftPage/LeftMargin/InventoryVbox/Item Slots/Inventory Row5"

@onready var temporaryItemLocation = get_parent()

var hasItemGrabbed: bool = false

var inventorySlotArray: Array[Node]

enum inventoryInputState{
	noItemGrabbed,
	hasItemGrabbed,
}

func _ready() -> void:
	GlobalSignalBus.updateInventoryUI.connect(updateWeightBar)
	GlobalSignalBus.inventorySlotPressed.connect(inventoryGrabAndMove)
	updateWeightBar()
	getAllSlots()

func getAllSlots() -> void:
	for slot in inventory_row_1.get_children():
		inventorySlotArray.append(slot)
	for slot in inventory_row_2.get_children():
		inventorySlotArray.append(slot)
	for slot in inventory_row_3.get_children():
		inventorySlotArray.append(slot)
	for slot in inventory_row_4.get_children():
		inventorySlotArray.append(slot)
	for slot in inventory_row_5.get_children():
		inventorySlotArray.append(slot)

func updateWeightBar() -> void:
	weight_bar.max_value = UtilsGlobalVariables.playerDataRef.inventoryRef.maxWeight
	weight_bar.value = GlobalInventoryHandler.getCurrentWeightOfInventory(UtilsGlobalVariables.playerDataRef.inventoryRef)
	weight_label.text = "Weight: " + str(weight_bar.value) + " / " + str(weight_bar.max_value)

func inventoryGrabAndMove(slotUUID: int, forceClose: bool) -> void:
	for slot in inventorySlotArray:
		if slot.inventorySlotUUID == slotUUID:
			clickedNode = slot
			break
	if !hasItemGrabbed:
		if UtilsGlobalVariables.playerDataRef.inventoryRef.inventory[slotUUID].item != null:
			visualNode = clickedNode.duplicate()
			mouseOffset = get_global_mouse_position() - clickedNode.global_position
			visualNode.set_script(null)
			visualNode.name = "DuplicateItem"
			visualNode.size = clickedNode.size
			visualNode.mouse_filter = Control.MOUSE_FILTER_IGNORE
			visualNode.get_node("InventorySlotButton").queue_free()
			visualNode.texture = null
			visualNode.position = get_global_mouse_position() - mouseOffset
			temporaryItemLocation.add_child(visualNode)
			hasItemGrabbed = true
			grabbedItemOriginalNode = clickedNode
			grabbedItemOriginalUUID = slotUUID
			clickedNode.get_node("MarginContainer").get_node("Item Icon").hide()
			clickedNode.get_node("MarginContainer").get_node("ItemAmountLabel").hide()
	elif hasItemGrabbed:
		#Move item to empty node
		if UtilsGlobalVariables.playerDataRef.inventoryRef.inventory[slotUUID].item == null:
			GlobalInventoryHandler.moveItemsFromSlotToEmptySlot(UtilsGlobalVariables.playerDataRef.inventoryRef, grabbedItemOriginalUUID, slotUUID)
		elif UtilsGlobalVariables.playerDataRef.inventoryRef.inventory[slotUUID].item != null:
			GlobalInventoryHandler.swapItemsBetweenSlots(UtilsGlobalVariables.playerDataRef.inventoryRef, grabbedItemOriginalUUID, slotUUID)
		hasItemGrabbed = false
		visualNode.queue_free()
		grabbedItemOriginalNode.get_node("MarginContainer").get_node("Item Icon").show()
		grabbedItemOriginalNode.get_node("MarginContainer").get_node("ItemAmountLabel").show()
		GlobalSignalBus.updateInventoryHotbar.emit()

func _input(event):
	if event is InputEventMouseMotion && hasItemGrabbed:
		visualNode.position = Vector2(0.0,0.0) #Reset position offset when mouse inputs are detected
		visualNode.position = get_global_mouse_position() - mouseOffset
		visualNode.size = clickedNode.size
