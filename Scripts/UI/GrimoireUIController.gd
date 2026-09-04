extends TextureRect

@onready var category_label: Label = $"Top icon Margin/VBoxContainer/MarginContainer/MarginContainer/Category Label"
@onready var iventory_back_texture: TextureRect = $"Top icon Margin/VBoxContainer/HBoxContainer/Iventory Back Texture"
@onready var recipes_back_texture: TextureRect = $"Top icon Margin/VBoxContainer/HBoxContainer/Recipes Back Texture"
@onready var compendium_back_texture: TextureRect = $"Top icon Margin/VBoxContainer/HBoxContainer/Compendium Back Texture"
@onready var records_back_texture: TextureRect = $"Top icon Margin/VBoxContainer/HBoxContainer/Records Back Texture"
@onready var inventory_button: Button = $"Top icon Margin/VBoxContainer/HBoxContainer/Iventory Back Texture/InventoryButton"
@onready var recipes_button: Button = $"Top icon Margin/VBoxContainer/HBoxContainer/Recipes Back Texture/RecipesButton"
@onready var compendium_button: Button = $"Top icon Margin/VBoxContainer/HBoxContainer/Compendium Back Texture/CompendiumButton"
@onready var records_button: Button = $"Top icon Margin/VBoxContainer/HBoxContainer/Records Back Texture/RecordsButton"
@onready var inventory_page_margin: MarginContainer = $"Inventory Page Margin"
@onready var recipes_page_margin: MarginContainer = $"Recipes Page Margin"
@onready var compendium_page_margin: MarginContainer = $"Compendium Page Margin"
@onready var records_page_margin: MarginContainer = $"Records Page Margin"

const GRIMOIRE_UI_TOP_ICON_SELECTED = preload("uid://co87p0yuffsoi")
const GRIMOIRE_UI_TOP_ICON_UNSELECTED = preload("uid://bo30pf7pm15jy")

enum categories{
	inventory,
	recipes,
	compendium,
	records
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	changeGrimoireCategory(categories.inventory)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.visible: mouse_filter = Control.MOUSE_FILTER_IGNORE
	else: mouse_filter = Control.MOUSE_FILTER_STOP
	
	if Input.is_action_just_pressed("Open_Grimoire"):
		self.visible = !self.visible
		if self.visible:
			AudioController.playEvent(preload("uid://4ap0gofrn21a"))

func changeGrimoireCategory(category: categories):
	if self.visible:
		AudioController.playEvent(preload("uid://4ap0gofrn21a"))
	match category:
		0:
			category_label.text = "Inventory"
			selectTopIcon(iventory_back_texture)
			deselectTopIcon(recipes_back_texture)
			deselectTopIcon(compendium_back_texture)
			deselectTopIcon(records_back_texture)
			inventory_page_margin.visible = true
			recipes_page_margin.visible = false
			compendium_page_margin.visible = false
			records_page_margin.visible = false
		1:
			category_label.text = "Recipes"
			deselectTopIcon(iventory_back_texture)
			selectTopIcon(recipes_back_texture)
			deselectTopIcon(compendium_back_texture)
			deselectTopIcon(records_back_texture)
			inventory_page_margin.visible = false
			recipes_page_margin.visible = true
			compendium_page_margin.visible = false
			records_page_margin.visible = false
		2:
			category_label.text = "Compendium"
			deselectTopIcon(iventory_back_texture)
			deselectTopIcon(recipes_back_texture)
			selectTopIcon(compendium_back_texture)
			deselectTopIcon(records_back_texture)
			inventory_page_margin.visible = false
			recipes_page_margin.visible = false
			compendium_page_margin.visible = true
			records_page_margin.visible = false
		3:
			category_label.text = "Records"
			deselectTopIcon(iventory_back_texture)
			deselectTopIcon(recipes_back_texture)
			deselectTopIcon(compendium_back_texture)
			selectTopIcon(records_back_texture)
			inventory_page_margin.visible = false
			recipes_page_margin.visible = false
			compendium_page_margin.visible = false
			records_page_margin.visible = true

func deselectTopIcon(backTexture: TextureRect):
	backTexture.texture = GRIMOIRE_UI_TOP_ICON_UNSELECTED
	await TopUIMovementTween(backTexture, Vector2(0,0), 0.1).finished

func selectTopIcon(backTexture: TextureRect):
	backTexture.texture = GRIMOIRE_UI_TOP_ICON_SELECTED
	await TopUIMovementTween(backTexture, Vector2(0,-4), 0.1).finished

func TopUIMovementTween(backTexture: TextureRect, to: Vector2, duration: float):
	var movementTween: Tween = null
	movementTween = get_tree().create_tween()
	movementTween.tween_property(backTexture, "offset_transform_position", to, duration)
	movementTween.set_ease(Tween.EASE_OUT)
	movementTween.set_trans(Tween.TRANS_CUBIC)
	return movementTween


func _on_inventory_button_pressed() -> void:
	changeGrimoireCategory(categories.inventory)


func _on_recipes_button_pressed() -> void:
	changeGrimoireCategory(categories.recipes)


func _on_compendium_button_pressed() -> void:
	changeGrimoireCategory(categories.compendium)


func _on_records_button_pressed() -> void:
	changeGrimoireCategory(categories.records)
