extends Node
class_name LevelManager

@export var start_time: int
@export var end_time: int
@export var hour_length_real_time: int = 1 #in mins
@export var level_data: LevelData = null

@export var max_madness: float = 100
@export var madness_one_threshold: float = 25
@export var madness_two_threshold: float = 50
@export var madness_three_threshold: float = 75

@export var radio: RadioManager
@export var recorder: Recorder

var madness_level: float
var level_name: String = ""
var hour_timer: Timer
var current_time: int

func _ready():
	_init_hour_timer()
	current_time = start_time
	if level_data: _load_level_data(level_data)

func _hour_passed():
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
	hour_timer.wait_time = hour_length_real_time*60
	hour_timer.timeout.connect(_hour_passed)
	add_child(hour_timer)
	hour_timer.start()

func get_anomaly_stations():
	if level_data:
		return level_data.get("anomaly_stations")

func update_madness_effects():
	print(madness_level)

func add_madness(amt: float):
	madness_level += amt
	update_madness_effects()
	
func open_phone_menu(): #phone menu will have invisible rect to capture input and make machine interaction impossible
	pass

func get_stations():
	if level_data:
		return level_data.get("level_stations")
