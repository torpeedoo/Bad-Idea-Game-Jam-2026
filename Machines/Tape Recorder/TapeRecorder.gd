extends Node2D

var current_station: Station = null
var is_recording = false
var recordings = {}

var _current_station_recording: Station = null
var _current_station_recording_duration = 0.0

func set_current_station(station: Station, strength: float):
	if strength > 0.1:
		current_station = station
	else:
		current_station = null

func start_recording(): 
	recordings.clear()
	is_recording = true

func stop_recording():
	_save_current_clip()
	
	_current_station_recording = null
	_current_station_recording_duration = 0.0
	
	is_recording = false
	
	print("Recorded morse station with total duration %f" % _get_total_station_recordings("Morse"))

func _process(delta: float) -> void:
	# For testing
	if Input.is_action_just_pressed("recording"): start_recording()
	if Input.is_action_just_released("recording"): stop_recording()
	
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
		recordings[_current_station_recording.station_name] = recording_bit

func _get_total_station_recordings(station_name: String) -> float:
	return recordings[station_name]["duration"]
