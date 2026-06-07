extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 80  # speed in pixels/sec
var accel = 32


func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = lerp(velocity, direction * speed, delta * accel)
	if velocity.x <= 0:
		animated_sprite_2d.flip_h=direction.x
	if direction.x != 0.0 && direction.y != 0.0:
		position = round(position)
	move_and_slide()
