extends Node

var currentPlayerPos: Vector2
var currentPlayerState: UtilsGlobalEnums.playerState
var playerDataRef: PlayerData = preload("uid://daghgr4dl3pxr")

var playerGatheringRange: int = 50

var currentSeason: UtilsGlobalEnums.seasons = UtilsGlobalEnums.seasons.Spring
var currentWeather: UtilsGlobalEnums.weatherState

var MusicBusLevel: int = 0
