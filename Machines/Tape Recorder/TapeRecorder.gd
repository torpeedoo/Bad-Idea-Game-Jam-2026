extends Node2D
class_name Recorder

signal song_recorded(song: Song)

@export_category("References")
@export var level_manager: LevelManager
@export var recorder_buttons: RecorderButtons
@export var empty_bay_sprite: Sprite2D
@export var loaded_bay_sprite: Sprite2D
@export var tape_location_marker: Marker2D
@export var tape_enter_audio: AudioStreamPlayer
@export var record_timer: Timer
@export var tape_bay_open_empty: Sprite2D
@export var tape_bay_open_full: Sprite2D
@export var record_bar: ProgressBar

@export_category("Params")
@export var record_length: float

@export var shake_strength := 2.0
@export var shake_speed := 20.0
var bar_original_pos := Vector2.ZERO
var shake_time := 0.0

var current_tape: Tape = null
var current_station: Station = null
var is_recording := false
var recordings := {}
var recording_time_elapsed : float = 0.0

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
	if record_timer:
		if current_tape: record_length = current_tape.tape_record_time
		record_bar.show()
		recording_time_elapsed = 0.0
		record_bar.max_value = record_length
		record_bar.value = 0
		record_timer.start(record_length)
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
	
	record_bar.hide()
	record_bar.value = 0
	
	if current_tape:
		loaded_bay_sprite.hide()
		tape_bay_open_full.show()
	
	eject_tape()
	
	if get_tape_recording(current_tape): print("recorded: "+str(get_tape_recording(current_tape).get(1)))

func recording_time_up():
	if is_recording:
		recorder_buttons.record_switch()

func set_tape(tape: Tape):
	if current_tape: return
	
	current_tape = tape
	tape_enter_audio.play()
	current_tape.hide()
	tape_bay_open_empty.hide()
	tape_bay_open_full.show()

func eject_tape():
	if is_recording or !current_tape: return
	
	current_tape.show()
	current_tape = null
	tape_bay_open_empty.show()
	tape_bay_open_full.hide()

func _ready():
	record_bar.hide()
	bar_original_pos = record_bar.position
	
	if recorder_buttons:
		recorder_buttons.clicked_record.connect(record_button_pressed)
		recorder_buttons.eject_clicked.connect(eject_button_pressed)
	if record_timer:
		record_timer.timeout.connect(recording_time_up)

func _process(delta: float) -> void:
	
	if !record_timer.is_stopped():
		recording_time_elapsed += delta
		record_bar.value = recording_time_elapsed
	
	if is_recording:
		shake_time += delta
		
		var progress_ratio := 0.0
		if record_bar.max_value > 0:
			progress_ratio = record_bar.value / record_bar.max_value
		
		progress_ratio = pow(progress_ratio, 1.5)
		
		var dynamic_strength = shake_strength * progress_ratio
		
		var offset_x = sin(shake_time * shake_speed) * dynamic_strength
		var offset_y = cos(shake_time * shake_speed * 0.8) * dynamic_strength * 0.5
		
		record_bar.position = bar_original_pos + Vector2(offset_x, offset_y)
	else:
		record_bar.position = bar_original_pos
		
	if not is_recording: return
	
	if _current_station_recording == current_station:
		_current_station_recording_duration += delta
	else:
		_save_current_clip()
		
		_current_station_recording = current_station
		_current_station_recording_duration = 0.0

func _save_current_clip():
	if _current_station_recording_duration > 0:
		if current_tape and _current_station_recording:
			level_manager.radio._fade_stations()
			current_tape.record_station(_current_station_recording.current_song, _current_station_recording_duration)
			song_recorded.emit(_current_station_recording.current_song)

func get_tape_recording(tape: Tape):
	if !tape: return
	
	return [tape.recorded_song, tape.recorded_duration]
