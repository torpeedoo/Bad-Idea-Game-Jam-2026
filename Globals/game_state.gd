extends Node

var current_station_index = -1
var is_recording = false
var recordings = []

var _current_station_recording_index = -1
var _current_station_recording_duration = 0.0

func set_current_station(index: int, strength: float):
	if strength > 0.1:
		current_station_index = index
	else:
		current_station_index = -1


func start_recording(): 
	recordings.clear()
	is_recording = true

func stop_recording():
	_save_current_clip()
	
	_current_station_recording_index = -1
	_current_station_recording_duration = 0.0
	
	is_recording = false
	
	print("Recorded no station with total duration %f" % _get_total_station_recordings(-1))
	print("Recorded station 0 with total duration %f" % _get_total_station_recordings(0))
	print("Recorded station 1 with total duration %f" % _get_total_station_recordings(1))


func _process(delta: float) -> void:
	# For testing
	if Input.is_action_just_pressed("recording"): start_recording()
	if Input.is_action_just_released("recording"): stop_recording()
	
	if not is_recording: return
	
	if _current_station_recording_index == current_station_index:
		_current_station_recording_duration += delta
	else:
		_save_current_clip()
		
		_current_station_recording_index = current_station_index
		_current_station_recording_duration = 0.0


func _save_current_clip():
	if _current_station_recording_duration > 0:
		var recording_bit = {
			"station_index": _current_station_recording_index,
			"duration": _current_station_recording_duration
		}
		recordings.append(recording_bit)


func _get_total_station_recordings(station_index: int) -> float:
	return recordings.reduce(
		func(accum, clip):
			if clip.station_index == station_index:
				return accum + clip.duration
			else:
				return accum,
		0.0
	)
