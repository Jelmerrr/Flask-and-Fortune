extends CharacterBody2D

@export var playerData: PlayerData

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 80 #Speed in pixels/sec
var accel = 16 #Acceleration in pixel/sec

func _ready() -> void:
	UtilsGlobalVariables.currentPlayerState = UtilsGlobalEnums.playerState.Free

func _physics_process(delta):
	if UtilsGlobalVariables.currentPlayerState == UtilsGlobalEnums.playerState.Free:
		#Get direction based on input and lerp it based on accel value
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = lerp(velocity, direction * speed, delta * accel)
		#Flip sprite based on movement TODO: Change this to 4/8 directional when player art is properly done
		if velocity.x <= 0:
			animated_sprite_2d.flip_h=direction.x
		#Round position if moving diagonal for smoother camera
		move_and_slide()
		position = round(position)
		UtilsGlobalVariables.currentPlayerPos = position
