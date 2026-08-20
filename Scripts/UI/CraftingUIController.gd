extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.visible: mouse_filter = Control.MOUSE_FILTER_IGNORE
	else: mouse_filter = Control.MOUSE_FILTER_PASS
	
	if Input.is_action_just_pressed("Open_Grimoire"):
		self.visible = !self.visible
		AudioController.playEvent(preload("uid://4ap0gofrn21a"))
