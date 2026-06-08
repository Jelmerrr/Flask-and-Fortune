extends Node2D

@export var gatherableData: GatherableObject

@onready var gather_object_sprite: Sprite2D = $GatherObjectSprite
@onready var gather_mouse_area: Area2D = $GatherObjectSprite/GatherMouseArea
@onready var gather_collision_shape: CollisionShape2D = $GatherObjectSprite/GatherMouseArea/GatherCollisionShape
@onready var gather_duration_timer: Timer = $GatherDurationTimer

func _ready() -> void:
	if gatherableData != null:
		gather_duration_timer.wait_time = gatherableData.baseGatherTime

func _on_gather_mouse_area_mouse_entered() -> void:
	gather_object_sprite.material.set_shader_parameter("strength", 1)

func _on_gather_mouse_area_mouse_exited() -> void:
	gather_object_sprite.material.set_shader_parameter("strength", 0)
