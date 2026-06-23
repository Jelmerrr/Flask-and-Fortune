extends Node

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
			for slot in recipe.results:
				print(str(slot.item.name) + " " + str(slot.amount) + "x")
			GlobalIventoryHandler.printInventory(UtilsGlobalVariables.playerDataRef.inventoryRef)
			#SignalBus.Set_Player_State.emit(Utils.PlayerStates.Free)

func ingredientsCheck(recipe: CraftingRecipe) -> bool:
	for slot in recipe.ingredients:
		if !GlobalIventoryHandler.hasItemAmount(slot.item, slot.amount, UtilsGlobalVariables.playerDataRef.inventoryRef):
			print("Craft failed, not enough items")
			return false
	return true

func useItems(recipe: CraftingRecipe) -> void:
	for slot in recipe.ingredients:
		for i in range(slot.amount):
			GlobalIventoryHandler.removeItem(slot.item, UtilsGlobalVariables.playerDataRef.inventoryRef)

func giveResults(recipe: CraftingRecipe) -> void:
	for slot in recipe.results:
		for i in range(slot.amount):
			GlobalIventoryHandler.addItem(slot.item, UtilsGlobalVariables.playerDataRef.inventoryRef)
