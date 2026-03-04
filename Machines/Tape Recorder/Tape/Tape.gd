extends Node2D
class_name Tape

@export var home_location: Marker2D
@export var drag_area: Area2D
@export var drag_parent: Node

var recorder: Recorder = null
var in_recorder_area: bool = false

var recorded_station: Station
var recorded_duration: float
var recording_strendth: float

var dragging := false

func _ready():
	if drag_area:
		drag_area.input_event.connect(_on_click)
		drag_area.area_entered.connect(check_overlapping_recorder)
		drag_area.area_exited.connect(check_overlapping_recorder_exit)

func _on_click(viewport: Node, input: InputEvent, shape_idx: int):
	if input is InputEventMouseButton:
		if input.button_index == MOUSE_BUTTON_LEFT:
			if input.pressed:
				print("hit")
				dragging = true
			else:
				drag_end()

func _physics_process(delta):
	if dragging:
		drag_logic()

func drag_logic():
	drag_parent.global_position = drag_parent.global_position.lerp(get_global_mouse_position(), 0.2)

func check_overlapping_recorder(area: Area2D):
	if area.is_in_group("recorder"):
		in_recorder_area = true
		if area.get_parent().get_parent() is Recorder:
			recorder = area.get_parent().get_parent()
	else:
		in_recorder_area = false

func check_overlapping_recorder_exit(area: Area2D):
	if area.is_in_group("recorder"):
		in_recorder_area = false
		recorder = null

func move_tape(to_marker: Marker2D):
	global_position= to_marker.global_position

func drag_end():
	dragging = false
	
	if in_recorder_area:
		move_tape(recorder.tape_location_marker)
		recorder.set_tape(self)
		
	if home_location:
		drag_parent.global_position = home_location.global_position
	
