extends Control

func _ready() -> void:
	#Force control objects to be alligned to 480 x 270 scale 
	#(mostly to prevent entire control modules misalligning with world scale)
	for child in self.get_children():
		child.position = child.position.snapped(Vector2(2,2))
