extends Node

signal addItems(ItemResource, Inventory, int)
signal removeItems(ItemResource, Inventory, int)

signal newDay()

signal isOutside(bool) #Emit this whenever the player changes from inside to outside, used for lighting and visuals.
signal isRaining(bool) #Emit this whenever weather changes to rain, used for lighting and visuals.
