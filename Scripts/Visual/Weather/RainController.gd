extends CanvasLayer

var isOutside: bool

var isRaining: bool:
	set(value):
		isRaining = value
		if value:
			AudioController.PlaySFX(preload("uid://8wx74w5vnf4y"), 0, 5)
		else:
			AudioController.StopSFX(preload("uid://8wx74w5vnf4y"))

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var color_rect: ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.isOutside.connect(changeOutsideState)
	GlobalSignalBus.isRaining.connect(updateRainSignal)

func changeOutsideState(state: bool):
	isOutside = state

func updateRainSignal(state: bool):
	isRaining = state

func _physics_process(delta: float) -> void:
	if isOutside && isRaining:
		gpu_particles_2d.visible = true
		color_rect.visible = true
	else:
		gpu_particles_2d.visible = false
		color_rect.visible = false
