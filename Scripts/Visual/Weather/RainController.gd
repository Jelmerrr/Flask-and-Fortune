extends CanvasLayer

@export var isEnabled: bool

var isRaining: bool:
	set(value):
		isRaining = value
		GlobalSignalBus.isRaining.emit(isRaining)
		if value:
			AudioController.PlaySFX(preload("uid://8wx74w5vnf4y"), 0)
		else:
			AudioController.StopSFX(preload("uid://8wx74w5vnf4y"))

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var color_rect: ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.isOutside.connect(changeState)

func changeState(state: bool):
	isEnabled = state

func _physics_process(delta: float) -> void:
	if isEnabled && isRaining:
		gpu_particles_2d.visible = true
		color_rect.visible = true
	else:
		gpu_particles_2d.visible = false
		color_rect.visible = false
