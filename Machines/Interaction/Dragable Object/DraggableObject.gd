extends Node2D
class_name DraggableObject

signal in_recorder_area(area: Area2D)
signal in_inv_slot_area(area: Area2D)
signal mouse_entered
signal mouse_exited
signal started_drag
signal ended_drag

@export var home_location: Marker2D
@export var drag_area: Area2D
@export var drag_parent: Node
@export var drag_audio: AudioStreamPlayer

var current_inv_slot: InventorySlot = null
var area_in: Area2D
var dragging := false
var _hovered: bool = false

func _ready():
	if drag_area:
		drag_area.input_event.connect(_on_click)
		drag_area.area_entered.connect(check_overlapping_enter)
		drag_area.area_exited.connect(check_overlapping_exit)
		drag_area.mouse_entered.connect(mouse_enter)
		drag_area.mouse_exited.connect(mouse_exit)

func mouse_enter():
	_hovered = true
	mouse_entered.emit()

func mouse_exit():
	_hovered = false
	mouse_exited.emit()

func _on_click(viewport: Node, input: InputEvent, shape_idx: int):
	if input.is_action_pressed("lmb"):
		drag_start()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb") and _hovered and not dragging:
		drag_start()

func _process(delta):
	if dragging:
		if Input.is_action_just_released("lmb"):
			drag_end()
		else:
			drag_logic(delta)

func drag_logic(delta):
	drag_parent.global_position = lerp(drag_parent.global_position, get_global_mouse_position(), 20*delta)

func check_overlapping_enter(area: Area2D):
	area_in = area

func check_overlapping_exit(area: Area2D):
	if area_in == area:
		area_in = null

func move_object(to_marker: Marker2D):
	global_position = to_marker.global_position
	reparent(to_marker)

func drag_start():
	started_drag.emit()
	show()
	dragging = true

func drag_end():
	dragging = false
	ended_drag.emit()
	if area_in:
		if area_in.is_in_group("recorder"):
			if area_in.get_parent().get_parent() is Recorder:
				if current_inv_slot: current_inv_slot.item_left()
				current_inv_slot = null
				in_recorder_area.emit(area_in)
		elif area_in.get_parent() is InventorySlot:
			var result = area_in.get_parent().set_item(self)
			if result:
				if current_inv_slot: current_inv_slot.item_left()
				current_inv_slot = area_in.get_parent()
				move_object(area_in.get_parent().item_storage_marker)
				in_inv_slot_area.emit(area_in)
	if home_location:
		drag_parent.global_position = home_location.global_position
