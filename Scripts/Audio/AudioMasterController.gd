extends Node2D

var fadeTween: Tween = null
const SFX_PLAYER = preload("uid://dtvxwurcomani")

@onready var music_player: AudioStreamPlayer2D = $MusicPlayer
@onready var sfx_channels: Node2D = $"SFX Channels"

func _ready() -> void:
	PlayMusic()

func FadeIn(audioPlayer: AudioStreamPlayer2D):
	audioPlayer.volume_db = -100
	VolumeTween(audioPlayer, 0, 0.5)

func FadeOut(audioPlayer: AudioStreamPlayer2D):
	audioPlayer.volume_db = 0
	await VolumeTween(audioPlayer, -100, 0.5).finished
	audioPlayer.stop()

func VolumeTween(audioPlayer: AudioStreamPlayer2D, to: float, duration: float):
	if fadeTween: fadeTween.kill()
	fadeTween = get_tree().create_tween()
	fadeTween.tween_property(audioPlayer, "volume_db", to, duration)
	fadeTween.set_ease(Tween.EASE_OUT)
	return fadeTween

func PlayMusic() -> void:
	#This should be somewhere else when options menu gets implemented
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music Master"), UtilsGlobalVariables.MusicBusLevel)
	
	if !music_player.playing:
		music_player.stream = preload("uid://m2b0xgpj324s") #preload("uid://cb66p1ejyerpc")
		FadeIn(music_player)
		music_player.play()

func PlaySFX(AudioFile: AudioStreamWAV, offset: int) -> void:
	print(sfx_channels)
	var instance = SFX_PLAYER.instantiate()
	instance.stream = AudioFile
	instance.offset = offset
	sfx_channels.add_child.call_deferred(instance)

func StopSFX(AudioFile: AudioStreamWAV) -> void:
	for player in sfx_channels.get_children():
		if player.stream == AudioFile:
			FadeOut(player)

func IsSooundAlreadyPlaying(AudioFile: AudioStreamWAV) -> bool:
	for player in sfx_channels.get_children():
		if player.stream == AudioFile:
			return true
	return false
