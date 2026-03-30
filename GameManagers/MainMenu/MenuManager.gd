extends Node2D
class_name MainMenuManager

@export_category("Refs")
@export_subgroup("audio")
@export var music: AudioStreamPlayer
@export_subgroup("Buttons")
@export var levels_button: Button
@export var settings_button: Button
@export var quit_button: Button
@export var credits_button: Button
@export_subgroup("Controls")
@export var levels_control: Control
@export var main_menu_control: Control
@export var settings_control: Control
@export var bg_control: Control
@export var credits_control: Control
@export var new_level_sprite: Sprite2D
@export_category("vars")
@export var level_button_array: Array[MainMenuButton]
@export var parallax_strength: float = 20.0
@export var parallax_smoothing: float = 5.0

var new_level: bool = false
var prev_control: Control
var current_control: Control
var _screen_center: Vector2
var _bg_origin: Vector2


func _ready():
	get_tree().paused = false
	_screen_center = get_viewport().get_visible_rect().size / 2.0
	if main_menu_control:
		main_menu_control.show()
	if bg_control:
		_bg_origin = bg_control.position
	if quit_button:
		quit_button.pressed.connect(Game_Manager.quit_game)
	if levels_button:
		levels_button.pressed.connect(open_levels)
	if levels_control:
		levels_control.hide()
	if settings_button:
		settings_button.pressed.connect(open_settings)
		settings_control.hide()
	if credits_control:
		credits_control.hide()
	if credits_button:
		credits_button.pressed.connect(open_credits)
	update_levels()

func open_levels():
	Game_Manager.seen_up_to_level = Game_Manager.unlocked_level
	new_level = false
	levels_control.show()
	main_menu_control.hide()
	current_control = levels_control
	prev_control = main_menu_control
	
func open_credits():
	credits_control.show()
	main_menu_control.hide()
	current_control = credits_control
	prev_control = main_menu_control

func open_settings():
	settings_control.show()
	main_menu_control.hide()
	current_control = settings_control
	prev_control = main_menu_control

func go_back():
	if !prev_control: return
	prev_control.show()
	current_control.hide()
	current_control = prev_control
	prev_control = null

func open_level(level: String):
	Game_Manager.change_scene(level)

func update_levels():
	var index := 1
	for btn in level_button_array:
		if index <= Game_Manager.unlocked_level:
			btn.disabled = false
		index += 1
	new_level = Game_Manager.unlocked_level > Game_Manager.seen_up_to_level

func _process(delta):
	if new_level:
		new_level_sprite.show()
	else:
		new_level_sprite.hide()
	if !bg_control:
		return
	if !music.playing: music.play()
	var mouse := get_viewport().get_mouse_position()
	var offset := (mouse + _screen_center) / _screen_center * parallax_strength * -1.0
	bg_control.position = lerp(bg_control.position, _bg_origin + offset, parallax_smoothing * delta)
