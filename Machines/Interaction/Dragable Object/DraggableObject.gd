extends Node2D
class_name DraggableObject

signal drag_ended

@export var home_location: Marker2D
@export var drag_area: Area2D
@export var drag_parent: Node

var dragging := false

func _ready():
	if drag_area:
		drag_area.input_event.connect(_on_click)

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

func drag_end():
	dragging = false
	if home_location:
		drag_parent.global_position = home_location.global_position
	
