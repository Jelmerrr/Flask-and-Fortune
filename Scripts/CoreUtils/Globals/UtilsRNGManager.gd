extends Node

var rng = RandomNumberGenerator.new()
var seedrng = RandomNumberGenerator.new()
@export var seed_input: String = "" #initial seed input for manual overwrite

func _ready() -> void:
	if seed_input == "":
		random_seed()
	elif seed_input != "":
		change_seed(seed_input)

func change_seed(new_seed): #Change seed based on input.
	rng.seed = hash(new_seed)

func random_seed(): #Generate a new random seed, should be called when no pre-determined seed was chosen.
	var randomseed = seedrng.randi_range(1, 2147483647)
	var randomized_seed = str(randomseed)
	rng.seed = hash(randomized_seed)

func shuffleArray(array: Array):
	for i in array.size() - 2:
		var j := rng.randi_range(i, array.size() - 1)
		var tmp = array[i]
		array[i] = array[j]
		array[j] = tmp
	return array

func weightedLootTable(lootTable: LootTableResource) -> Array[ItemResource]:
	var result: Array[ItemResource]
	var weighting: PackedFloat32Array
	for item in lootTable.lootTable:
		weighting.append(item.rarityWeigth)
	for rolls in lootTable.itemsRollAmount:
		var rngresult = rng.rand_weighted(weighting)
		var itemAmount = rng.randi_range(lootTable.lootTable[rngresult].amountMin, lootTable.lootTable[rngresult].amountMax)
		for n in itemAmount:
			result.append(lootTable.lootTable[rngresult].Item)
	return result
