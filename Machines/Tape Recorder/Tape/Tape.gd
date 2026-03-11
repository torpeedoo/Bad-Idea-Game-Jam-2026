extends DraggableObject
class_name Tape

@export var freq_label: Label
@export var tape_sprite: Sprite2D
@export var pickup_sound: AudioStreamPlayer
@export var drop_sound: AudioStreamPlayer

var recorded_station: Station
var recorded_duration: float
var recording_strendth: float

func _ready():
	tape_sprite.use_parent_material = true
	in_recorder_area.connect(drag_ended_recorder)
	started_drag.connect(show_shadow)
	ended_drag.connect(hide_shadow)
	freq_label.text = ""
	super._ready()

func show_shadow():
	pickup_sound.play()
	tape_sprite.use_parent_material = false

func hide_shadow():
	drop_sound.play()
	tape_sprite.use_parent_material = true

func record_station(station: Station, recorded_dur: float, recording_str: float = 1.0):
	recorded_station = station
	recorded_duration = recorded_dur
	recording_strendth = recording_str
	if recorded_station: freq_label.text = str(recorded_station.station_freq)

func drag_ended_recorder(area: Area2D):
	var recorder: Recorder = area.get_parent().get_parent()
	recorder.set_tape(self)
	move_object(recorder.tape_location_marker)
