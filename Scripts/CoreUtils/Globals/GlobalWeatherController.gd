extends Node

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
			GlobalSignalBus.isOutside.emit(true)
		UtilsGlobalEnums.weatherState.Fog:
			#do some foggy stuf here in future
			pass

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	changeWeather(UtilsGlobalEnums.weatherState.Raining)
