extends Node
class_name Gamemanager

var songs_recorded: Array[Song]
var currency: int = 0
var main_menu_path: String = "res://GameManagers/MainMenu/MainMenu.tscn"
const popup_path: String = "res://GameManagers/ConfirmationPopup/ConfirmationPopup.tscn"
const loading_screen_path: String = "res://GameManagers/LoadingScreen/LoadingScreen.tscn"
var unlocked_level: int = 1
var tutorial_completed: bool = false

var _target_scene: String = ""

var _dither_rect: ColorRect
const DITHER_IN_TIME: float = 0.4 
const DITHER_OUT_TIME: float = 0.4

func _ready() -> void:
	_setup_dither_overlay()

func _setup_dither_overlay() -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = 100
	add_child(canvas)

	_dither_rect = ColorRect.new()
	_dither_rect.anchor_right = 1.0
	_dither_rect.anchor_bottom = 1.0
	_dither_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_dither_rect.material = load("res://Shaders/transition.tres")
	_set_dither(2.0)
	canvas.add_child(_dither_rect)

func _set_dither(value: float) -> void:
	_dither_rect.material.set_shader_parameter("radius", value)

func _dither_in() -> Signal:
	var tween := create_tween()
	tween.tween_method(_set_dither, 2.0, 0.0, DITHER_IN_TIME)
	return tween.finished

func _dither_out() -> Signal:
	var tween := create_tween()
	tween.tween_method(_set_dither, 0.0, 2.0, DITHER_OUT_TIME)
	return tween.finished

func change_scene(scene_path: String) -> void:
	_target_scene = scene_path
	await _dither_in()
	get_tree().change_scene_to_file(loading_screen_path)
	await _dither_out()

func get_target_scene() -> String:
	return _target_scene

func finish_level(anomalies_found: int, level_data: LevelData, level_manager: LevelManager, songs_recorded: Array[Song]) -> void:
	currency += (anomalies_found * level_data.anomaly_bounty)
	if anomalies_found >= level_data.anomalies_pass_num:
		unlocked_level = max(unlocked_level, level_data.night_number + 1)
	print(unlocked_level)
	change_scene(main_menu_path)

func quit_game() -> void:
	get_tree().quit()
