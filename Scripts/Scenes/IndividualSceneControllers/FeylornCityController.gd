extends Node2D

func _ready() -> void:
	GlobalSignalBus.isOutside.emit(true)
