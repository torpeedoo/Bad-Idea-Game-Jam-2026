extends Node2D
class_name CustomCursor

@export var hand_managers: Array[HandManager]
@export var cursor_parent: Node2D

var current_manager: HandManager = null
var madness_level: int = 0
var clicking: bool = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	for manager in hand_managers:
		manager._init_hands()
		if manager.madness_level == madness_level:
			manager.show()

func _process(delta):
	cursor_parent.global_position = get_global_mouse_position()
	update_hand_sprite()
	
	if Input.is_action_just_pressed("lmb"):
		_on_click()
	elif Input.is_action_just_released("lmb"):
		_on_unclick()

func _on_unclick():
	if !clicking or !current_manager: return
	
	clicking = false
	current_manager.open_hand()

func _on_click():
	if clicking or !current_manager: return
	
	clicking = true
	current_manager.close_hand()

func update_madness(val: int):
	madness_level = val

func update_hand_sprite():
	for manager in hand_managers:
		if manager.madness_level == madness_level:
			current_manager = manager
			manager.show()
		else:
			manager.hide()
