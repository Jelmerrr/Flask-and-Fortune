extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 60  # speed in pixels/sec
var accel = 32


func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = lerp(velocity, direction * speed, delta * accel)
	if direction.x <= 0:
		animated_sprite_2d.flip_h=direction.x
	move_and_slide()
