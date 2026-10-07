extends Node

func _ready() -> void:
	GlobalSignalBus.addItems.connect(addItems)
	GlobalSignalBus.removeItems.connect(removeItems)

func generateInventory(inventoryReference: Inventory) -> void:
	while inventoryReference.inventory.size() < inventoryReference.maxSlots:
		var newItem: InventorySlot = InventorySlot.new()
		inventoryReference.inventory.append(newItem)

func addItems(item: ItemResource, inventoryReference: Inventory, amount: int) -> void:
	#Adds item of defined amount to referenced inventory
	#If the item does not exist inside the given inventory, assign a new slot for it
	var slot = hasItemInSlot(item, inventoryReference)
	if slot != null:
		slot.amount += amount
	else:
		#inventoryReference.inventory.append(new_slot(item, amount))
		if hasEmptySlotInInventory(inventoryReference):
			#For extremely large inventories might be more efficient to return empty slot found in the empty slot check but for now this works fine
			for emptySlotCheck in inventoryReference.inventory:
				if emptySlotCheck.item == null:
					emptySlotCheck.item = item
					emptySlotCheck.amount = amount
					break
		else:
			#Do other logic here like item dropping on ground etc.
			print("Can't insert item. Inventory is full")
	if !item.playerHasKnowledgeOfItem:
		item.playerHasKnowledgeOfItem = true
		GlobalSignalBus.gainKnowledgeOfItem.emit(item)
	GlobalSignalBus.updateInventoryUI.emit()
	GlobalSignalBus.updateInventoryHotbar.emit()
	GlobalSignalBus.updateRecipeBook.emit()

func removeItems(item: ItemResource, inventoryReference: Inventory, amount: int) -> void:
	#Removes item of defined amount to referenced inventory
	#If the inventory slot becomes empty, remove it from the inventory
	var slot = hasItemInSlot(item, inventoryReference)
	if slot != null:
		if slot.amount >= amount:
			slot.amount -= amount
		else:
			print("Not enough items in inventory to remove specified amount")
			return
		if slot.amount <= 0:
			inventoryReference.inventory[slot].item = null #Might cause issues, too lazy to test properly but worked the 1 time I did test it.
			inventoryReference.inventory[slot].amount = 0
	else:
		print("Item to remove not found!")
	GlobalSignalBus.updateInventoryUI.emit()
	GlobalSignalBus.updateInventoryHotbar.emit()

func hasItemInSlot(item: ItemResource, inventoryReference: Inventory) -> InventorySlot: 
	#Call this when we care about which slot the item is located at, not the amount.
	#Used internally to see if an item already exist within an inventory before creating a new dedicated slot for it.
	for slot in inventoryReference.inventory:
		if slot.item == item:
			return slot
	return null

func hasItemAmountInInventory(item: ItemResource, amount: int, inventoryReference: Inventory) -> bool: 
	#Call this when we care about the count of an item, not in which slot it is.
	#Mostly used for crafting checks for sufficient items.
	for slot in inventoryReference.inventory:
		if slot.item == item && slot.amount >= amount:
			return true
	return false

func new_slot(item: ItemResource, amount: int) -> InventorySlot:
	var newItem: InventorySlot = InventorySlot.new()
	newItem.item = item
	newItem.amount = amount
	return newItem

func hasEmptySlotInInventory(inventoryReference: Inventory) -> bool:
	for emptySlotCheck in inventoryReference.inventory:
		if emptySlotCheck.item == null:
			return true
	return false

func getCurrentWeightOfInventory(inventoryReference: Inventory) -> float:
	var result: float = 0.0
	for slot in inventoryReference.inventory:
		if slot.item != null:
			result += (slot.item.itemWeight * slot.amount)
	return result

func printInventory(inventoryReference: Inventory) -> void:
	print("Current Inventory:")
	for slot in inventoryReference.inventory:
		if slot.item != null:
			print(slot.item.itemName + " " + str(slot.amount) + "x")
		else:
			print("Empty")

func moveItemsFromSlotToEmptySlot(inventoryReference: Inventory, fromUUID: int, toUUID: int):
	if inventoryReference.inventory[toUUID].item == null:
		inventoryReference.inventory[toUUID].item = inventoryReference.inventory[fromUUID].item
		inventoryReference.inventory[toUUID].amount = inventoryReference.inventory[fromUUID].amount
		inventoryReference.inventory[fromUUID].item = null #Might cause issues, too lazy to test properly but worked the 1 time I did test it.
		inventoryReference.inventory[fromUUID].amount = 0
	GlobalSignalBus.updateInventoryUI.emit()

func swapItemsBetweenSlots(inventoryReference: Inventory, fromUUID: int, toUUID: int):
	if inventoryReference.inventory[toUUID].item != null:
		var fromSlot: InventorySlot = InventorySlot.new()
		fromSlot.item = inventoryReference.inventory[fromUUID].item
		fromSlot.amount = inventoryReference.inventory[fromUUID].amount
		
		var toSlot: InventorySlot = InventorySlot.new()
		toSlot.item = inventoryReference.inventory[toUUID].item
		toSlot.amount = inventoryReference.inventory[toUUID].amount
		
		inventoryReference.inventory[toUUID].item = fromSlot.item
		inventoryReference.inventory[fromUUID].item = toSlot.item
		
		inventoryReference.inventory[toUUID].amount = fromSlot.amount
		inventoryReference.inventory[fromUUID].amount = toSlot.amount
	GlobalSignalBus.updateInventoryUI.emit()
