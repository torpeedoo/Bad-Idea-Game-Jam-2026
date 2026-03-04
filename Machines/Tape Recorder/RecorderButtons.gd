extends Node2D
class_name RecorderButtons

signal clicked_record

@export var recording_state: bool = false
@export var record_interaction_area: Area2D
@export var record_switch_down_sprite: Sprite2D
@export var click_sfx: AudioStreamPlayer

var is_clicking: bool = false

func _ready():
	if record_interaction_area:
		record_interaction_area.input_event.connect(on_record_click)

func _process(delta):
	if is_clicking:
		if Input.is_action_just_released("lmb"):
			unclick()

func record_switch():
	recording_state = !recording_state
	record_switch_down_sprite.visible = recording_state

func unclick():
	pass

func play_sfx():
	if !click_sfx:
		return
	click_sfx.play()

func on_record_click(viewport: Node, input: InputEvent, shape_idx: int):
	if input.is_action_pressed("lmb"):
		record_switch()
		play_sfx()
		is_clicking = true
		clicked_record.emit()
