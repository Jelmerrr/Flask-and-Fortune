extends Node2D

var fadeTween: Tween = null
const SFX_PLAYER = preload("uid://dtvxwurcomani")

@onready var music_player: AudioStreamPlayer2D = $MusicPlayer
@onready var sfx_channels: Node2D = $"SFX Channels"

var musicVolumeDB = 0
var sfxVolumeDB = 0

func _ready() -> void:
	PlayMusic()

func FadeIn(audioPlayer: AudioStreamPlayer2D, volumeTarget: int, fadeLength: float):
	audioPlayer.volume_db = -100
	await VolumeTween(audioPlayer, volumeTarget, fadeLength)

func FadeOut(audioPlayer: AudioStreamPlayer2D, fadeLength: float):
	audioPlayer.volume_db = 0
	await VolumeTween(audioPlayer, -100, fadeLength).finished
	audioPlayer.stop()

func VolumeTween(audioPlayer: AudioStreamPlayer2D, to: float, duration: float):
	fadeTween = get_tree().create_tween()
	fadeTween.tween_property(audioPlayer, "volume_db", to, duration)
	fadeTween.set_ease(Tween.EASE_OUT)
	fadeTween.set_trans(Tween.TRANS_EXPO)
	return fadeTween

func PlayMusic() -> void:
	#This should be somewhere else when options menu gets implemented
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music Master"), UtilsGlobalVariables.MusicBusLevel)
	
	if !music_player.playing:
		music_player.stream = preload("uid://m2b0xgpj324s") #preload("uid://cb66p1ejyerpc")
		FadeIn(music_player, musicVolumeDB, 0.5)
		music_player.play()

func PlaySFX(AudioFile: AudioStreamWAV, offset: int, fadeInLength: float) -> void:
	var instance = SFX_PLAYER.instantiate()
	var shouldFade: bool = false
	instance.stream = AudioFile
	instance.offset = offset
	if !fadeInLength <= 0:
		shouldFade = true
	sfx_channels.add_child.call_deferred(instance)
	if shouldFade:
		FadeIn(instance, sfxVolumeDB, fadeInLength)

func StopSFX(AudioFile: AudioStreamWAV, fadeOutLength: float) -> void:
	for player in sfx_channels.get_children():
		if player.stream == AudioFile:
			FadeOut(player, fadeOutLength)

func IsSooundAlreadyPlaying(AudioFile: AudioStreamWAV) -> bool:
	for player in sfx_channels.get_children():
		if player.stream == AudioFile:
			return true
	return false

func playEvent(event: AudioEvent):
	if event.eventType == UtilsGlobalEnums.audioEventTypes.SFX:
		PlaySFX(event.audioFile[randi_range(0, event.audioFile.size() - 1)], event.offsetOverride, event.fadeInTime)
