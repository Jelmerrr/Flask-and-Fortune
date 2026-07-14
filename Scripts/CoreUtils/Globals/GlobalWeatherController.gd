extends Node

var isWeatherActive: bool = true

#Inteval for each weather cycle attempt
var weatherCycleWaitIntervalMin: float = 60.0 #in seconds
var weatherCycleWaitIntervalMax: float = 180.0 #in seconds

var timeSinceLastWeatherRollAttempt: int = 0

var weatherChanceDict: Dictionary[String, PackedFloat32Array] = {
	"Spring": [1.0,2.0]
}

var currentWeather: UtilsGlobalEnums.weatherState:
	set(value):
		currentWeather = value
		GlobalSignalBus.changeWeather.emit(value)
		sendGlobalWeatherStateSignals(value)

func changeWeather(newWeather: UtilsGlobalEnums.weatherState) -> void:
	currentWeather = newWeather

func sendGlobalWeatherStateSignals(newWeather: UtilsGlobalEnums.weatherState) -> void:
	match newWeather:
		UtilsGlobalEnums.weatherState.Sunny:
			GlobalSignalBus.isRaining.emit(false)
			pass
		UtilsGlobalEnums.weatherState.Raining:
			GlobalSignalBus.isRaining.emit(true)
			pass

func _ready() -> void:
	weatherCycle()

func weatherCycle() -> void:
	await get_tree().create_timer(UtilsRngManager.rng.randf_range(weatherCycleWaitIntervalMin, weatherCycleWaitIntervalMax)).timeout
	if shouldRollNewWeather():
		var selectedWeather: UtilsGlobalEnums.weatherState
		var currentSeason = UtilsGlobalEnums.seasons.keys()[UtilsGlobalVariables.currentSeason]
		selectedWeather = UtilsRngManager.rng.rand_weighted(weatherChanceDict[currentSeason]) as UtilsGlobalEnums.weatherState
		changeWeather(selectedWeather)
	resetWeatherCycle()

func resetWeatherCycle() -> void:
	if isWeatherActive:
		weatherCycle()

func shouldRollNewWeather() -> bool:
	#TODO: Add some more complex algorithm here like accounting for season changes or a logarithmic function.
	if UtilsRngManager.percentChance(50):
		return true
	return false
