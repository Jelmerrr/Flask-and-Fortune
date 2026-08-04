extends Node

var currentPlayerPos: Vector2
var currentPlayerState: UtilsGlobalEnums.playerState
var playerDataRef: PlayerData = preload("uid://daghgr4dl3pxr")

var currentPlayerSelectedHotbarSlot: int = 0:
	set(value):
		currentPlayerSelectedHotbarSlot = clamp(value, 0, 4)
		GlobalSignalBus.changeSelectedHotbarSlotUI.emit()

var playerGatheringRange: int = 50

var currentSeason: UtilsGlobalEnums.seasons = UtilsGlobalEnums.seasons.Spring
var currentWeather: UtilsGlobalEnums.weatherState

var MusicBusLevel: int = 0
