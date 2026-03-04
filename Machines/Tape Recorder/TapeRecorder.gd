extends Node2D

@export_category("References")
@export var recorder_buttons: RecorderButtons
@export var empty_bay_sprite: Sprite2D
@export var loaded_bay_sprite: Sprite2D

var current_tape: Node
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
	
	print("Recorded morse station with total duration %f" % _get_total_station_recordings("Morse"))

func _ready():
	if recorder_buttons:
		recorder_buttons.clicked_record.connect(record_button_pressed)

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
		var recording_bit = {
			"station": _current_station_recording,
			"duration": _current_station_recording_duration
		}
		if _current_station_recording: recordings[_current_station_recording.station_name] = recording_bit

func _get_total_station_recordings(station_name: String) -> float:
	var _recording = recordings.get(station_name)
	if _recording: return _recording.get("duration")
	else: return 0.0
	
