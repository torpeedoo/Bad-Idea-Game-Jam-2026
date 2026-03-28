extends Node
class_name RadioManager

@export_category("References")
@export var tune_dial: Dial
@export var freq_display: Label
@export var static_audio: AudioStreamPlayer
@export var am_fm_switch: CustomSwitch
@export var meter_marker: Sprite2D
@export var meter_start_marker: Marker2D
@export var meter_end_marker: Marker2D
@export var recorder: Node
@export var level_manager: LevelManager
@export var madness_timer: Timer

@export_category("Params")
@export var stations: Array[Station] = []
@export_range(88.0, 106.0, 0.2) var frequency
@export var am_fm: Station.AM_FM = Station.AM_FM.FM
@export var madness_add_cooldown: float = 0.2

var current_station: Station
var meter_target_position: Vector2
var am_bounds: Array = [0, 18]
var fm_bounds: Array = [80, 110]
var station_audiostreams: Array[AudioStreamPlayer] = []

func _ready():
	_init_madness_timer()
	if meter_marker and meter_start_marker:
		meter_marker.position = meter_start_marker.position
	if tune_dial:
		_am_fm_change()
		tune_dial.moved_dial.connect(_update_freq)
	if am_fm_switch:
		am_fm_switch.clicked.connect(_am_fm_change)

func _process(delta):
	if static_audio and !static_audio.playing:
		static_audio.play()
	
	if meter_marker and meter_target_position:
		meter_marker.position = meter_marker.position.lerp(
			meter_target_position,
			delta * 8.0
		)

func _update_meter():
	if not meter_marker or not meter_start_marker or not meter_end_marker:
		return
	
	var min_freq = tune_dial.min_val
	var max_freq = tune_dial.max_val
	
	var t = inverse_lerp(min_freq, max_freq, frequency)
	t = clamp(t, 0.0, 1.0)
	
	meter_target_position = meter_start_marker.position.lerp(meter_end_marker.position, t)

func _fade_stations():
	var strongest_signal := 0.0
	var best_station : Station = null

	if station_audiostreams.size() == 0:
		return

	for i in range(stations.size()):
		if i >= station_audiostreams.size():
			continue

		var station = stations[i]
		var player = station_audiostreams[i]

		# Skip invalid stations
		if am_fm != station.am_fm or !station.broadcasting:
			player.volume_db = -80
			continue

		var distance = abs(frequency - station.station_freq)
		var strength = clamp(1.0 - (distance / station.bandwith), 0.0, 1.0)
		strength *= strength

		if strength > strongest_signal:
			strongest_signal = strength
			best_station = station

		if strength > 0.001:
			player.volume_db = linear_to_db(strength)
		else:
			player.volume_db = -80.0

	if strongest_signal < 0.01:
		current_station = null
		if recorder:
			recorder.set_current_station(null, 0.0)
	else:
		current_station = best_station
		if recorder:
			recorder.set_current_station(best_station, strongest_signal)

	if static_audio:
		var static_strength = clamp(1.0 - strongest_signal, 0.0, 1.0)
		var min_db = -15.0

		if static_strength > 0.001:
			static_audio.volume_db = max(linear_to_db(static_strength), min_db)
		else:
			static_audio.volume_db = min_db

func _update_audiostreams():
	if !station_audiostreams: return
	var index := 0
	
	for stream in station_audiostreams:
		var station = stations.get(index)
		print("called")
		
		if station.current_song:
			
			if station.current_song.is_anomaly:
				stream.pitch_scale = randf_range(0.7, 0.9)
			else:
				stream.pitch_scale = 1.0
			
			station.broadcasting = true
			stream.stream = station.current_song.audiostream
			stream.play()
		index += 1

func _load_stations():
	station_audiostreams = []
	
	for _station in stations:
		var temp_station = AudioStreamPlayer.new()
		
		if !_station.current_song: return
		
		temp_station.name = _station.station_name + "_audiostream"
		temp_station.stream = _station.current_song.audiostream
		if temp_station.stream is not AudioStreamWAV: 
			temp_station.stream.loop = true
		temp_station.volume_db = -80
		temp_station.bus = "Radio"
		add_child(temp_station)
		temp_station.play()
		station_audiostreams.append(temp_station)

func _update_display():
	freq_display.text = str(snapped(frequency, 0.01))

func _am_fm_change():
	if am_fm_switch.switch_state == true:
		am_fm = Station.AM_FM.AM
	elif am_fm_switch.switch_state == false:
		am_fm = Station.AM_FM.FM
	
	# Clear current station so old band can't be recorded
	current_station = null
	if recorder:
		recorder.set_current_station(null, 0.0)

	if am_fm == Station.AM_FM.FM:
		tune_dial.min_val = fm_bounds[0]
		tune_dial.max_val = fm_bounds[1]
	elif am_fm == Station.AM_FM.AM:
		tune_dial.min_val = am_bounds[0]
		tune_dial.max_val = am_bounds[1]
		
	_update_freq()

func _update_freq():
	frequency = tune_dial.get_val()
	_update_display()
	_update_meter()
	_fade_stations()

func _init_madness_timer():
	if !madness_timer: return
	
	madness_timer.wait_time = madness_add_cooldown
	madness_timer.timeout.connect(_madness_timer_timeout)
	madness_timer.start()

func _madness_timer_timeout():
	if !current_station: return
	if !current_station.current_song: return
	
	if current_station.current_song.is_anomaly and current_station.am_fm == am_fm:
		level_manager.add_madness()

func get_current_station():
	return current_station
