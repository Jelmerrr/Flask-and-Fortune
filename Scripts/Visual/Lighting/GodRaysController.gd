extends ColorRect

@export_range(0.0, 1.0, 0.01) var morningTwilightTime: float
@export_range(0.0, 1.0, 0.01) var morningTwilightLength: float

@export var rayColor: Color

var rayVisible: bool = false
var isMorning = true
var tweenDuration: float

func _ready() -> void:
	#I hecking love math
	#automatically adjust god ray easing based on length of day and length of godray
	GlobalSignalBus.newDay.connect(newDay)
	tweenDuration = ((asin((2 * morningTwilightLength) - 1) + 0.5 * PI) / GlobalTimeOfDayController.timeScaleMultiplier) / 4

func newDay() -> void:
	isMorning = true

func _physics_process(_delta: float) -> void:
	var value = (sin(GlobalTimeOfDayController.time - 0.5 * PI) + 1.0) * 0.5
	if isMorning:
		if value >= morningTwilightTime && value <= (morningTwilightLength + morningTwilightTime) && !rayVisible:
			rayVisible = true
			showGodRays(tweenDuration)
		elif value >= (morningTwilightLength + morningTwilightTime) && rayVisible:
			rayVisible = false
			hideGodRays(tweenDuration)
			isMorning = false

func showGodRays(duration: float) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(setShaderColorParam, Color("ffe6a600"), rayColor, duration)

func hideGodRays(duration: float) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(setShaderColorParam, rayColor, Color("ffe6a600"), duration)

func setShaderColorParam(value: Color):
	material.set_shader_parameter("color", value)
