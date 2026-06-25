extends CanvasModulate

@export var gradient: GradientTexture1D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var value = (sin(GlobalTimeOfDayController.time - 0.5 * PI) + 1.0) * 0.5
	self.color = gradient.gradient.sample(value)
