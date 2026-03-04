extends Node

@export_category("References")
@export var tune_dial: Dial
@export var freq_display: Label
@export var static_audio: AudioStreamPlayer
@export var am_fm_switch: CustomSwitch
@export var meter_marker: Sprite2D
@export var meter_start_marker: Marker2D
@export var meter_end_marker: Marker2D
@export var recorder: Node

@export_category("Params")
@export var stations: Array[Station] = []
@export_range(88.0, 106.0, 0.2) var frequency
@export var am_fm: Station.AM_FM = Station.AM_FM.FM

var current_station: Array = []
var meter_target_position: Vector2
var am_bounds: Array = [0, 18]
var fm_bounds: Array = [80, 110]
var station_audiostreams: Array[AudioStreamPlayer] = []

func _ready():
	if meter_marker and meter_start_marker:
		meter_marker.position = meter_start_marker.position
	if tune_dial:
		_am_fm_change()
		tune_dial.moved_dial.connect(_update_freq)
	if am_fm_switch:
		am_fm_switch.clicked.connect(_am_fm_change)
	if stations:
		_load_stations()

func _process(delta):
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
	
	if station_audiostreams.size() == 0:
		return
	
	for i in range(stations.size()):
		var station = stations[i]
		
		if am_fm != station.am_fm or !station.broadcasting:
			
			if station_audiostreams.size() > i:
				station_audiostreams[i].volume_db = -80
			
			continue
		
		var player = station_audiostreams[i]
		
		var distance = abs(frequency - station.station_freq)
		var strength = clamp(1.0 - (distance / station.bandwith), 0.0, 1.0)
		
		strength = strength * strength
		
		strongest_signal = max(strongest_signal, strength)
		
		if strongest_signal == strength:
			if recorder: recorder.set_current_station(station, strength)
		
		if strength > 0.001:
			player.volume_db = linear_to_db(strength)
		else:
			player.volume_db = -80.0
		
	
	# Static gets louder when no station is strong
	if static_audio:
		var static_strength = clamp(1.0 - strongest_signal, 0.0, 1.0)
		
		if static_strength > 0.001:
			static_audio.volume_db = linear_to_db(static_strength)
		else:
			static_audio.volume_db = -80.0

func _load_stations():
	station_audiostreams = []
	
	for _station in stations:
		var temp_station = AudioStreamPlayer.new()
		temp_station.name = _station.station_name + "_audiostream"
		temp_station.stream = _station.audiostream
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

func get_current_station():
	return current_station
