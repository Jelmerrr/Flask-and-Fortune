extends CanvasModulate

@export var gradient: GradientTexture1D
@export var isEnabled: bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if isEnabled:
		var value = (sin(GlobalTimeOfDayController.time - 0.5 * PI) + 1.0) * 0.5
		self.color = gradient.gradient.sample(value)
	else:
		self.color = gradient.gradient.sample(1)
