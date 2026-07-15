extends CanvasLayer

var rect_tween: Tween = null
var particle_tween: Tween = null

var isOutside: bool

var rainActiveRectColor: Color = Color("#000000b4")
var rainDeactiveRectColor: Color = Color("00000000")

var rainActiveParticleAmount: int = 600
var rainDeactiveParticleAmount: int = 0

var rainStartDuration: float = 5.0
var rainEndDuration: float = 5.0

var isRaining: bool

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var color_rect: ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.changeWeather.connect(weatherProcess)
	GlobalSignalBus.isOutside.connect(changeOutsideState)

func changeOutsideState(state: bool):
	isOutside = state

func weatherProcess(weather: UtilsGlobalEnums.weatherState) -> void:
	if weather == UtilsGlobalEnums.weatherState.Raining:
		if !isRaining:
			AudioController.PlaySFX(preload("uid://8wx74w5vnf4y"), 0, rainStartDuration)
			rectTween(color_rect, rainActiveRectColor, rainStartDuration)
			particleTween(gpu_particles_2d, 1.0, rainStartDuration)
			isRaining = true
	else:
		AudioController.StopSFX(preload("uid://8wx74w5vnf4y"), rainEndDuration)
		rectTween(color_rect, rainDeactiveRectColor, rainEndDuration)
		particleTween(gpu_particles_2d, 0.0, rainEndDuration)
		isRaining = false

func _physics_process(_delta: float) -> void:
	if isOutside:
		gpu_particles_2d.visible = true
		color_rect.visible = true
	else:
		gpu_particles_2d.visible = false
		color_rect.visible = false

func rectTween(rect: ColorRect, to: Color, duration: float):
	rect_tween = get_tree().create_tween()
	rect_tween.tween_property(rect, "color", to, duration)
	rect_tween.set_ease(Tween.EASE_OUT)
	rect_tween.set_trans(Tween.TRANS_EXPO)
	return rect_tween

func particleTween(particle: GPUParticles2D, to: float, duration: float):
	particle_tween = get_tree().create_tween()
	particle_tween.tween_property(particle, "amount_ratio", to, duration)
	particle_tween.set_ease(Tween.EASE_OUT)
	particle_tween.set_trans(Tween.TRANS_EXPO)
	return particle_tween
