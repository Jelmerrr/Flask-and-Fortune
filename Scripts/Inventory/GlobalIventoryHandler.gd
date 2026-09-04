extends Node

func _ready() -> void:
	GlobalSignalBus.addItems.connect(addItems)
	GlobalSignalBus.removeItems.connect(removeItems)

func addItems(item: ItemResource, inventoryReference: Inventory, amount: int) -> void:
	#Adds item of defined amount to referenced inventory
	#If the item does not exist inside the given inventory, create a new slot for it
	var slot = hasItemInSlot(item, inventoryReference)
	if slot != null:
		slot.amount += amount
	else:
		inventoryReference.inventory.append(new_slot(item, amount))
	if !item.playerHasKnowledgeOfItem:
		item.playerHasKnowledgeOfItem = true
		GlobalSignalBus.gainKnowledgeOfItem.emit(item)

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
			inventoryReference.inventory.erase(slot) #Might cause issues, too lazy to test properly but worked the 1 time I did test it.
	else:
		print("Item to remove not found!")

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

func printInventory(inventoryReference: Inventory) -> void:
	print("Current Inventory:")
	for slot in inventoryReference.inventory:
		print(slot.item.itemName + " " + str(slot.amount) + "x")
