extends DraggableObject
class_name Tape

@export var freq_label: Label

var recorded_station: Station
var recorded_duration: float
var recording_strendth: float

func _ready():
	in_recorder_area.connect(drag_ended_recorder)
	freq_label.text = ""
	super._ready()

func record_station(station: Station, recorded_dur: float, recording_str: float = 1.0):
	recorded_station = station
	recorded_duration = recorded_dur
	recording_strendth = recording_str
	if recorded_station: freq_label.text = str(recorded_station.station_freq)

func drag_ended_recorder(area: Area2D):
	var recorder: Recorder = area.get_parent().get_parent()
	recorder.set_tape(self)
	move_object(recorder.tape_location_marker)
