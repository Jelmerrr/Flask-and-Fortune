extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Force control objects to be alligned to 480 x 270 scale
	for child in self.get_children():
		child.position = child.position.snapped(Vector2(2,2))
