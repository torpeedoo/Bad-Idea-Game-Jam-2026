extends Node2D
class_name CustomButton

signal clicked
signal mouse_entered
signal mouse_exited

@export var interaction_area: Area2D
@export var button_up_sprite: Node
@export var button_down_sprite: Node
@export var click_sfx: AudioStreamPlayer

var is_clicking: bool = false
var _hovered: bool = false

func _ready():
	if interaction_area:
		interaction_area.input_event.connect(on_click)
		interaction_area.mouse_entered.connect(mouse_enter)
		interaction_area.mouse_exited.connect(mouse_exit)

func mouse_enter():
	_hovered = true
	mouse_entered.emit()

func mouse_exit():
	_hovered = false
	mouse_exited.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb") and _hovered and not is_clicking:
		click()

func _process(delta):
	if is_clicking:
		if Input.is_action_just_released("lmb"):
			unclick()

func click():
	is_clicking = true
	if button_down_sprite and button_up_sprite:
		button_down_sprite.show()
		button_up_sprite.hide()
	clicked.emit()
	play_click_sfx()

func unclick():
	if button_down_sprite and button_up_sprite:
		button_up_sprite.show()
		button_down_sprite.hide()
	is_clicking = false
	play_click_sfx()

func play_click_sfx():
	if click_sfx:
		click_sfx.play()

func on_click(viewport: Node, input: InputEvent, shape_idx: int):
	if input.is_action_pressed("lmb"):
		click()
