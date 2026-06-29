extends Node2D

@export var gatherableData: GatherableObject

@onready var gather_object_sprite: Sprite2D = $GatherObjectSprite
@onready var gather_mouse_area: Area2D = $GatherObjectSprite/GatherMouseArea
@onready var gather_collision_shape: CollisionShape2D = $GatherObjectSprite/GatherMouseArea/GatherCollisionShape
@onready var gather_duration_timer: Timer = $GatherDurationTimer

var entered_area: bool = false
var distance: float
var harvestable: bool = true

func _ready() -> void:
	if gatherableData != null:
		gather_duration_timer.wait_time = gatherableData.baseGatherTime

func _physics_process(_delta: float) -> void:
	#Every other frame, check harvestable objects if they are inside the gathering range of the player
	if Engine.get_physics_frames() % 2 == 0 && harvestable:
		distance = global_position.distance_to(UtilsGlobalVariables.currentPlayerPos)
		for child in gather_mouse_area.get_children():
			child.disabled = !distance <= UtilsGlobalVariables.playerGatheringRange

func _on_gather_mouse_area_mouse_entered() -> void:
	entered_area = true
	gather_object_sprite.material.set_shader_parameter("strength", 1)

func _on_gather_mouse_area_mouse_exited() -> void:
	entered_area = false
	gather_object_sprite.material.set_shader_parameter("strength", 0)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT && entered_area == true && distance <= 60 && UtilsGlobalVariables.currentPlayerState != UtilsGlobalEnums.playerState.Gathering:
			gather_duration_timer.wait_time = gatherableData.baseGatherTime
			gather_duration_timer.start()
			
			UtilsGlobalVariables.currentPlayerState = UtilsGlobalEnums.playerState.Gathering
			AudioController.PlaySFX(preload("uid://6uhxdfup02ac"), randi_range(0, 15))

func _on_gather_duration_timer_timeout() -> void:
	AudioController.PlaySFX(preload("uid://1cv8ihko1fky"), 0)
	AudioController.StopSFX(preload("uid://6uhxdfup02ac"))
	UtilsGlobalVariables.currentPlayerState = UtilsGlobalEnums.playerState.Free
	GatherResource()

func GatherResource() -> void:
	var gatherResult: Dictionary[ItemResource, int] = UtilsRngManager.weightedLootTable(gatherableData.lootTable)
	for item in gatherResult:
		GlobalSignalBus.addItems.emit(item, UtilsGlobalVariables.playerDataRef.inventoryRef, gatherResult[item])
	GlobalIventoryHandler.printInventory(UtilsGlobalVariables.playerDataRef.inventoryRef)
	harvestable = false
	gather_object_sprite.visible = false
