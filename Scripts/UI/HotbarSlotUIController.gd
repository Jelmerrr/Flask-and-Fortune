extends HBoxContainer

@onready var slot_1_texture: TextureRect = $"Slot 1/Slot 1 Texture"
@onready var slot_2_texture: TextureRect = $"Slot 2/Slot 2 Texture"
@onready var slot_3_texture: TextureRect = $"Slot 3/Slot 3 Texture"
@onready var slot_4_texture: TextureRect = $"Slot 4/Slot 4 Texture"
@onready var slot_5_texture: TextureRect = $"Slot 5/Slot 5 Texture"

const ITEM_HUD_SELECTED = preload("uid://c0c50ic8sjvib")
const ITEM_HUD_UNSELECTED = preload("uid://cuyxnujrd0mbu")

@onready var slotArray: Array[TextureRect] = [slot_1_texture, slot_2_texture, slot_3_texture, slot_4_texture, slot_5_texture]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateVisuals()
	GlobalSignalBus.changeSelectedHotbarSlotUI.connect(updateVisuals)

func updateVisuals() -> void:
	for slot in slotArray:
		if slot == slotArray[UtilsGlobalVariables.currentPlayerSelectedHotbarSlot]:
			slot.texture = ITEM_HUD_SELECTED
		else:
			slot.texture = ITEM_HUD_UNSELECTED

func _physics_process(_delta: float) -> void:
	#I want to do this cleaner but for some reason I can't get match statements to work with inputEvent shrug
	pass
	#for i in range(5):
		#if Input.is_action_just_pressed("HotbarSlot" + str(i+1)):
			#UtilsGlobalVariables.currentPlayerSelectedHotbarSlot = i

func _unhandled_input(event: InputEvent) -> void:
	if event == InputEventKey:
		print(event)
	for i in range(5):
		if Input.is_action_just_pressed("HotbarSlot" + str(i+1)):
			UtilsGlobalVariables.currentPlayerSelectedHotbarSlot = i
			get_viewport().set_input_as_handled()
