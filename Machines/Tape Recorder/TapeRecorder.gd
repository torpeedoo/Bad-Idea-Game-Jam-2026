extends Node2D
class_name Recorder

@export_category("References")
@export var recorder_buttons: RecorderButtons
@export var empty_bay_sprite: Sprite2D
@export var loaded_bay_sprite: Sprite2D
@export var tape_location_marker: Marker2D

var current_tape: Tape = null
var current_station: Station = null
var is_recording := false
var recordings := {}

var _current_station_recording: Station = null
var _current_station_recording_duration := 0.0

func set_current_station(station: Station, strength: float):
	if strength > 0.1:
		current_station = station
	else:
		current_station = null

func eject_button_pressed():
	if current_tape:
		eject_tape()

func record_button_pressed():
	if recorder_buttons.recording_state == true:
		start_recording()
	elif recorder_buttons.recording_state == false:
		stop_recording()

func start_recording(): 
	recordings.clear()
	is_recording = true

func stop_recording():
	_save_current_clip()
	
	_current_station_recording = null
	_current_station_recording_duration = 0.0
	
	is_recording = false

func set_tape(tape: Tape):
	current_tape = tape
	current_tape.hide()
	empty_bay_sprite.hide()
	loaded_bay_sprite.show()

func eject_tape():
	current_tape.show()
	current_tape = null
	empty_bay_sprite.show()
	loaded_bay_sprite.hide()

func _ready():
	if recorder_buttons:
		recorder_buttons.clicked_record.connect(record_button_pressed)
		recorder_buttons.eject_clicked.connect(eject_button_pressed)

func _process(delta: float) -> void:
	if not is_recording: return
	
	if _current_station_recording == current_station:
		_current_station_recording_duration += delta
	else:
		_save_current_clip()
		
		_current_station_recording = current_station
		_current_station_recording_duration = 0.0

func _save_current_clip():
	if _current_station_recording_duration > 0:
		if current_tape:
			current_tape.recorded_station = _current_station_recording
			current_tape.recorded_duration = _current_station_recording_duration

func get_tape_recording(tape: Tape):
	if !tape: return
	
	return [tape.recorded_station, tape.recorded_duration]
