extends DraggableObject
class_name Tape

var recorded_station: Station
var recorded_duration: float
var recording_strendth: float

func _ready():
	in_recorder_area.connect(drag_ended_recorder)
	super._ready()

func drag_ended_recorder(area: Area2D):
	var recorder: Recorder = area.get_parent().get_parent()
	recorder.set_tape(self)
	move_object(recorder.tape_location_marker)
