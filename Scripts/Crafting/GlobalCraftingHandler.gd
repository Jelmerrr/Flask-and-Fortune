extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("OpenCraftingUI"):
		craftItem(preload("uid://buwfq2onk8fm2"))

func craftItem(recipe: CraftingRecipe) -> void:
	if UtilsGlobalVariables.currentPlayerState == UtilsGlobalEnums.playerState.Free:
		print("Attempting craft")
		if ingredientsCheck(recipe):
			UtilsGlobalVariables.currentPlayerState = UtilsGlobalEnums.playerState.Crafting
			#SignalBus.start_Crafting.emit(recipe)
			await get_tree().create_timer(recipe.craftingTime).timeout
			useItems(recipe)
			giveResults(recipe)
			UtilsGlobalVariables.currentPlayerState = UtilsGlobalEnums.playerState.Free
			print("Items crafted:")
			#for slot in recipe.results.mainResults:
				#print(str(slot.item.name) + " " + str(slot.amount) + "x")
			GlobalIventoryHandler.printInventory(UtilsGlobalVariables.playerDataRef.inventoryRef)
			#SignalBus.Set_Player_State.emit(Utils.PlayerStates.Free)

func ingredientsCheck(recipe: CraftingRecipe) -> bool:
	for slot in recipe.ingredients:
		if !GlobalIventoryHandler.hasItemAmountInInventory(slot.item, slot.amount, UtilsGlobalVariables.playerDataRef.inventoryRef):
			print("Craft failed, not enough items")
			return false
	return true

func useItems(recipe: CraftingRecipe) -> void:
	for slot in recipe.ingredients:
		for i in range(slot.amount):
			GlobalIventoryHandler.removeItems(slot.item, UtilsGlobalVariables.playerDataRef.inventoryRef, 1)

func giveResults(recipe: CraftingRecipe) -> void:
	var craftingMainResult: Dictionary[ItemResource, int] = UtilsRngManager.weightedLootTable(recipe.results.mainResults)
	for item in craftingMainResult:
		GlobalSignalBus.addItems.emit(item, UtilsGlobalVariables.playerDataRef.inventoryRef, craftingMainResult[item])
	if UtilsRngManager.percentChance(recipe.results.byproductChance):
		var craftingByproductsResult: Dictionary[ItemResource, int] = UtilsRngManager.weightedLootTable(recipe.results.byproductResults)
		for item in craftingByproductsResult:
			GlobalSignalBus.addItems.emit(item, UtilsGlobalVariables.playerDataRef.inventoryRef, craftingByproductsResult[item])
