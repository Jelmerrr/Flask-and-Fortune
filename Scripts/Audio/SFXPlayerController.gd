extends AudioStreamPlayer2D

var offset: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play(offset)


func _on_finished() -> void:
	queue_free()
