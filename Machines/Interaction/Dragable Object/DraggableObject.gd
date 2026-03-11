extends Node2D
class_name DraggableObject

signal in_recorder_area(area: Area2D)
signal in_inv_slot_area(area: Area2D)

signal started_drag
signal ended_drag

@export var home_location: Marker2D
@export var drag_area: Area2D
@export var drag_parent: Node
@export var drag_audio: AudioStreamPlayer

var area_in: Area2D

var dragging := false

func _ready():
	if drag_area:
		drag_area.input_event.connect(_on_click)
		drag_area.area_entered.connect(check_overlapping_enter)
		drag_area.area_exited.connect(check_overlapping_exit)

func _on_click(viewport: Node, input: InputEvent, shape_idx: int):
	if input is InputEventMouseButton:
		if input.button_index == MOUSE_BUTTON_LEFT:
			if input.pressed:
				drag_start()

func _physics_process(delta):
	if dragging:
		if Input.is_action_just_released("lmb"):
			drag_end()
		else:
			drag_logic()

func drag_logic():
	drag_parent.global_position = drag_parent.global_position.lerp(get_global_mouse_position(), 0.2)

func check_overlapping_enter(area: Area2D):
	area_in = area

func check_overlapping_exit(area: Area2D):
	if area_in == area:
		area_in = null

func move_object(to_marker: Marker2D):
	global_position = to_marker.global_position

func drag_start():
	started_drag.emit()
	dragging = true

func drag_end():
	dragging = false
	ended_drag.emit()
	
	if area_in:
		if area_in.is_in_group("recorder"):
			if area_in.get_parent().get_parent() is Recorder:
				in_recorder_area.emit(area_in)
		elif area_in.get_parent() is InventorySlot:
			area_in.get_parent().set_item(self)
			move_object(area_in.get_parent().item_storage_marker)
			in_inv_slot_area.emit(area_in)

	if home_location:
		drag_parent.global_position = home_location.global_position
	
