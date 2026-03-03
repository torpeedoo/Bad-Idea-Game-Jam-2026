extends Node2D
class_name CustomSwitch

signal clicked

@export var switch_state: bool = false
@export var interaction_area: Area2D
@export var switch_up_sprite: Node
@export var switch_down_sprite: Node
@export var click_sfx: AudioStreamPlayer

var is_clicking: bool = false

func _ready():
	switch()
	if interaction_area:
		interaction_area.input_event.connect(on_click)

func _process(delta):
	if is_clicking:
		if Input.is_action_just_released("lmb"):
			unclick()

func switch():
	switch_state = !switch_state
	switch_up_sprite.visible = switch_state
	switch_down_sprite.visible = !switch_state

func click():
	switch()
	play_sfx()
	is_clicking = true
	clicked.emit()

func unclick():
	pass

func play_sfx():
	if !click_sfx:
		return
	click_sfx.play()

func on_click(viewport: Node, input: InputEvent, shape_idx: int):
	if input.is_action_pressed("lmb"):
		click()
