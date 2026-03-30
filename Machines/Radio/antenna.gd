extends Node2D

@export var area: Area2D
@export var rotation_smoothing: float = 10.0
@export var drag_sensitivity: float = 0.01
@export var drag_audio: AudioStreamPlayer

var _dragging: bool = false
var _origin_rotation: float
var _target_rotation: float

func _ready():
	_origin_rotation = rotation
	_target_rotation = rotation
	if area:
		area.input_event.connect(_on_input_event)

func _on_input_event(viewport: Node, input: InputEvent, shape_idx: int):
	if input.is_action_pressed("lmb"):
		_dragging = true
	elif input.is_action_released("lmb"):
		_dragging = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("lmb"):
		_dragging = false
	if _dragging and event is InputEventMouseMotion:
		_target_rotation += event.relative.x * drag_sensitivity
		_target_rotation = clampf(_target_rotation, _origin_rotation - PI / 2.0, _origin_rotation + PI / 2.0)

func _process(delta: float) -> void:
	if not _dragging:
		drag_audio.stop()
	else:
		if !drag_audio.playing: drag_audio.play()
		rotation = lerp_angle(rotation, _target_rotation, rotation_smoothing * delta)
