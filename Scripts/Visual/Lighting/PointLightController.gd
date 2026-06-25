extends PointLight2D

@export var isDeterminedByDayNightCycle: bool
@export_range(0.0, 16.0) var maxEnergy: float = 1.0

func _physics_process(delta: float) -> void:
	if isDeterminedByDayNightCycle: self.energy = (-sin(GlobalTimeOfDayController.time - 0.5 * PI) + 1.0) * 0.5 * maxEnergy
