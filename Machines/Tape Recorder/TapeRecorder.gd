extends Node2D
class_name Recorder

@export_category("References")
@export var recorder_buttons: RecorderButtons
@export var empty_bay_sprite: Sprite2D
@export var loaded_bay_sprite: Sprite2D
@export var tape_location_marker: Marker2D
@export var tape_enter_audio: AudioStreamPlayer
@export var record_timer: Timer
@export var tape_bay_open_empty: Sprite2D
@export var tape_bay_open_full: Sprite2D

@export_category("Params")
@export var record_length: float

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
	if record_timer: record_timer.start(record_length)
	recordings.clear()
	is_recording = true
	if current_tape:
		loaded_bay_sprite.show()
		tape_bay_open_full.hide()

func stop_recording():
	if !is_recording: return
	
	_save_current_clip()
	
	_current_station_recording = null
	_current_station_recording_duration = 0.0
	
	is_recording = false
	
	if current_tape:
		loaded_bay_sprite.hide()
		tape_bay_open_full.show()
	
	if get_tape_recording(current_tape): print("recorded: "+str(get_tape_recording(current_tape).get(1)))

func recording_time_up():
	if is_recording:
		recorder_buttons.record_switch()

func set_tape(tape: Tape):
	current_tape = tape
	tape_enter_audio.play()
	current_tape.hide()
	tape_bay_open_empty.hide()
	tape_bay_open_full.show()

func eject_tape():
	current_tape.show()
	current_tape = null
	tape_bay_open_empty.show()
	tape_bay_open_full.hide()

func _ready():
	if recorder_buttons:
		recorder_buttons.clicked_record.connect(record_button_pressed)
		recorder_buttons.eject_clicked.connect(eject_button_pressed)
	if record_timer:
		record_timer.timeout.connect(recording_time_up)

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
			current_tape.record_station(_current_station_recording, _current_station_recording_duration)

func get_tape_recording(tape: Tape):
	if !tape: return
	
	return [tape.recorded_station, tape.recorded_duration]
