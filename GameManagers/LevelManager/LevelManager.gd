extends Node
class_name LevelManager

@export var start_time: int
@export var end_time: int
@export var hour_length_real_time: int = 1 #in mins
@export var level_data: LevelData = null

@export var radio: RadioManager
@export var recorder: Recorder

var level_name: String = ""
var hour_timer: Timer
var current_time: int

func _ready():
	_init_timer()
	current_time = start_time
	if level_data: _load_level_data(level_data)
	radio.stations = level_data.level_stations
	radio._load_stations()

func _hour_passed():
	level_data.hour_passed()
	current_time += 1
	print("hour passed")
	if current_time >= end_time:
		_reached_end_time()

func _reached_end_time():
	pass

func _load_level_data(level_data: LevelData):
	level_data.init_stations()
	level_name = level_data.level_name

func _init_timer():
	hour_timer = Timer.new()
	hour_timer.wait_time = hour_length_real_time*60
	hour_timer.timeout.connect(_hour_passed)
	add_child(hour_timer)
	hour_timer.start()

func get_anomaly_stations():
	if level_data:
		return level_data.get("anomaly_stations")

func get_stations():
	if level_data:
		return level_data.get("level_stations")
