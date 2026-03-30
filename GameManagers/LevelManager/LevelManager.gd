extends Node2D
class_name LevelManager

signal anomaly_found
signal anomaly_recorded
signal anomaly_submitted
signal hour_passed

@export_category("Time Settings")
@export var start_time: int
@export var end_time: int
@export var hour_length_real_time: int = 1

@export_category("Madness Settings")
@export var max_madness: float = 100
@export var madness_one_threshold: float = 25
@export var madness_two_threshold: float = 50
@export var madness_three_threshold: float = 75
@export var madness_add_amt: float = 1.0

@export_category("Refs")
@export_subgroup("BG")
@export var bg: Node2D
@export_subgroup("LevelData")
@export var level_data: LevelData = null
@export_subgroup("Madness")
@export var hallucination_animations: AnimatedSprite2D
@export var madness_audio1: AudioStreamPlayer
@export var grain: Grain
@export var madness_laugh_audio: AudioStreamPlayer
@export var madness_drone_audio: AudioStreamPlayer
@export var jump_scare: JumpScare
@export var tv: TV
@export_subgroup("Machines")
@export var recorder: Recorder
@export var radio: RadioManager
@export_subgroup("Managers")
@export var inventory: InventoryUI
@export_subgroup("Audio")
@export var ambiance: AudioStreamPlayer

var madness_level: float
var level_name: String = ""
var hour_timer: Timer
var current_time: int
var anomalies_found: int = 0
var songs_recorded: Array[Song] = []
var anomalies_recorded: Array[Song] = []
var current_madness_stage: int = 0
var _screen_center: Vector2
var _bg_origin: Vector2
var scaring: bool = false
var _madness_cooldown_timer: Timer

func _process(delta):
	if !ambiance.playing:
		ambiance.play()

func _ready():
	_init_hour_timer()
	_init_madness_cooldown_timer()
	current_time = start_time
	_screen_center = get_viewport().get_visible_rect().size / 2.0
	if bg:
		_bg_origin = bg.position
	if hallucination_animations: pass
	if madness_audio1: madness_audio1.volume_db = -80
	if level_data: _load_level_data(level_data)
	if recorder: recorder.song_recorded.connect(add_recorded_song)
	if hallucination_animations:
		hallucination_animations.animation_finished.connect(_on_hallucination_finished)

func _on_hallucination_finished():
	hallucination_animations.play("Nothing")

func _hour_passed():
	hour_passed.emit()
	level_data.hour_passed()
	radio._update_audiostreams()
	current_time += 1
	print("hour passed")
	if current_time >= end_time:
		_reached_end_time()

func _reached_end_time():
	pass

func _load_level_data(level_data: LevelData):
	level_data.init_stations()
	level_name = level_data.level_name
	if radio:
		radio.stations = get_stations()
		radio._load_stations()

func _init_hour_timer():
	hour_timer = Timer.new()
	hour_timer.wait_time = hour_length_real_time * 60
	hour_timer.timeout.connect(_hour_passed)
	add_child(hour_timer)
	hour_timer.start()

func _init_madness_cooldown_timer() -> void:
	_madness_cooldown_timer = Timer.new()
	_madness_cooldown_timer.wait_time = 5.0
	_madness_cooldown_timer.one_shot = true
	_madness_cooldown_timer.timeout.connect(_on_madness_cooldown_timeout)
	add_child(_madness_cooldown_timer)

func _on_madness_cooldown_timeout() -> void:
	if inventory:
		inventory.deactivate_scare()

func add_recorded_song(song: Song):
	anomaly_recorded.emit()
	if song not in songs_recorded:
		songs_recorded.append(song)

func end_level():
	Game_Manager.finish_level(anomalies_found, level_data, self, songs_recorded)

func get_anomaly_stations():
	if level_data:
		return level_data.get("anomaly_stations")

func update_madness_effects():
	if madness_audio1:
		madness_audio1.volume_db = remap(madness_level, 0.0, 100.0, -80, -10)
	if grain:
		grain.change_grain_str(madness_level / 100)
	update_hallucinations()

func _play_hallucination_once(anim_name: String):
	if not hallucination_animations:
		return
	hallucination_animations.sprite_frames.set_animation_loop(anim_name, false)
	hallucination_animations.play(anim_name)

func update_hallucinations():
	if madness_audio1.playing == false:
		madness_audio1.play()
	var new_stage := 0
	if madness_level >= madness_three_threshold:
		new_stage = 3
	elif madness_level >= madness_two_threshold:
		new_stage = 2
	elif madness_level >= madness_one_threshold:
		new_stage = 1
	if new_stage == current_madness_stage:
		return
	current_madness_stage = new_stage
	match current_madness_stage:
		0:
			hallucination_animations.play("Nothing")
			Custom_Cursor.update_madness(0)
			if tv: tv.stop_static()
		1:
			madness_drone_audio.play()
			_play_hallucination_once("WindowPeeper")
			Custom_Cursor.update_madness(1)
			if tv: tv.stop_static()
		2:
			madness_laugh_audio.play()
			_play_hallucination_once("GhostChildA")
			Custom_Cursor.update_madness(2)
			if tv: tv.play_static()
		3:
			madness_laugh_audio.play()
			_play_hallucination_once("GhostChildB")
			Custom_Cursor.update_madness(2)
			if tv: tv.play_static()

func fail_game():
	if jump_scare:
		jump_scare.scare_finished.connect(reload_scene)
		jump_scare.scare_trigger()
		scaring = true
	else:
		reload_scene()

func reload_scene():
	scaring = false
	get_tree().reload_current_scene()

func reduce_madness(amt: float):
	madness_level = clampf(madness_level - amt, 0.0, max_madness)
	if madness_level <= madness_one_threshold:
		Custom_Cursor.update_madness(0)
	elif madness_level <= madness_two_threshold:
		Custom_Cursor.update_madness(1)
	elif madness_level <= madness_three_threshold:
		Custom_Cursor.update_madness(2)
	update_madness_effects()

func add_madness():
	if madness_level < max_madness:
		if level_data.night_number == 3 and !inventory.jumpscare_active:
			var r = randf_range(0.0, 1.0)
			print(r)
			if r >= 0.99:
				inventory.activate_scare()
		madness_level += madness_add_amt
		update_madness_effects()
		anomaly_found.emit()
		_madness_cooldown_timer.start()
	elif madness_level >= max_madness and !scaring:
		fail_game()

func open_phone_menu():
	pass

func get_stations():
	if level_data:
		return level_data.get("level_stations")
