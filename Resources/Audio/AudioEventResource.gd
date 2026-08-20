extends Resource

class_name AudioEvent

@export var eventName: String
@export var eventType: UtilsGlobalEnums.audioEventTypes
@export var audioFile: Array[AudioStreamWAV]
@export var usesRandomizedOffset: bool
@export var randomizedOffsetRange: Vector2
@export var offsetOverride: float
@export var doesFade: bool
@export var fadeInTime: float
@export var fadeOutTime: float
