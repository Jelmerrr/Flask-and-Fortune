extends CanvasLayer

@export var isOutside: bool

@export var isRaining: bool:
	set(value):
		isRaining = value
		GlobalSignalBus.isRaining.emit(isRaining)
		if initialized:
			if value:
				AudioController.PlaySFX(preload("uid://8wx74w5vnf4y"), 0)
			else:
				AudioController.StopSFX(preload("uid://8wx74w5vnf4y"))

var initialized: bool = false #Safeguard to prevent systems loading before others

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var color_rect: ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.isOutside.connect(changeState)
	if isRaining:
		AudioController.PlaySFX(preload("uid://8wx74w5vnf4y"), 0)
	initialized = true

func changeState(state: bool):
	isOutside = state

func _physics_process(delta: float) -> void:
	if isOutside && isRaining:
		gpu_particles_2d.visible = true
		color_rect.visible = true
	else:
		gpu_particles_2d.visible = false
		color_rect.visible = false
