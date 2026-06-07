extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 80 #Speed in pixels/sec
var accel = 32 #Acceleration in pixel/sec

func _physics_process(delta):
	#Get direction based on input and lerp it based on accel value
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = lerp(velocity, direction * speed, delta * accel)
	#Flip sprite based on movement TODO: Change this to 4/8 directional when player art is properly done
	if velocity.x <= 0:
		animated_sprite_2d.flip_h=direction.x
	#Round position if moving diagonal for smoother camera
	if direction.x != 0.0 && direction.y != 0.0:
		position = round(position)
	#Adjust object position
	move_and_slide()
