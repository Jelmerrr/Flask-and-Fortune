extends Node

#Inteval for each weather cycle attempt
var weatherCycleWaitIntervalMin: float = 60.0 #in seconds
var weatherCycleWaitIntervalMax: float = 180.0 #in seconds

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
			#add some stuff here in future
			pass
		UtilsGlobalEnums.weatherState.Raining:
			GlobalSignalBus.isRaining.emit(true)
			pass

func _ready() -> void:
	startWeatherCycle()

func startWeatherCycle() -> void:
	await get_tree().create_timer(weatherCycleWaitIntervalMin).timeout
