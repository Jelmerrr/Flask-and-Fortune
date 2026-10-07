extends Node

signal addItems(ItemResource, Inventory, int)
signal removeItems(ItemResource, Inventory, int)

signal newDay()

#Weahter based signals
signal changeWeather(weatherState: UtilsGlobalEnums.weatherState)
signal isRaining(bool) #Emit this whenever weather changes to rain, used for lighting and visuals.

signal isOutside(bool) #Emit this whenever the player changes from inside to outside, used for lighting and visuals.

#UI based signals
signal changeSelectedHotbarSlotUI()
signal updateCompendiumRightPageText(item: ItemResource)
signal switchCompendiumPage(node: Node)
signal updateInventoryUI()
signal inventorySlotPressed(slotUUID: int, forceClose: bool)
signal updateInventoryHotbar()
signal updateRecipeBook()
signal switchSelectedRecipe(node: Node)
signal updateRecipeRightPage(recipe: CraftingRecipe)

#Item based signals
signal gainKnowledgeOfItem(item: ItemResource)
