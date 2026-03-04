extends Node2D
class_name RecorderButtons

signal clicked_record
signal eject_clicked

@export var recording_state: bool = false
@export var record_interaction_area: Area2D
@export var record_switch_down_sprite: Sprite2D
@export var click_sfx: AudioStreamPlayer

@export var eject_interaction_area: Area2D
@export var eject_button_down_sprite: Sprite2D

var is_clicking_eject: bool = false

func _ready():
	if record_interaction_area:
		record_interaction_area.input_event.connect(on_record_click)
		eject_interaction_area.input_event.connect(on_eject_click)

func _process(delta):
	if is_clicking_eject:
		if Input.is_action_just_released("lmb"):
			unclick_eject()

func record_switch():
	recording_state = !recording_state
	record_switch_down_sprite.visible = recording_state

func unclick_eject():
	play_sfx()
	eject_button_down_sprite.hide()
	is_clicking_eject = false

func play_sfx():
	if !click_sfx:
		return
	click_sfx.play()

func on_eject_click(viewport: Node, input: InputEvent, shape_idx: int):
	if input.is_action_pressed("lmb"):
		play_sfx()
		is_clicking_eject = true
		eject_button_down_sprite.show()
		eject_clicked.emit()

func on_record_click(viewport: Node, input: InputEvent, shape_idx: int):
	if input.is_action_pressed("lmb"):
		record_switch()
		play_sfx()
		clicked_record.emit()
