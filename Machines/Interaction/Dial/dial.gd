extends Node2D
class_name Dial

signal moved_dial

@export_category("References")
@export var knob: Marker2D
@export var knob_point: Marker2D
@export var middle_point: Marker2D

@export_category("Params")
@export var min_val: float = 0.0
@export var max_val: float = 100.0
@export var MAX_DIST := 6000

var following := false
var finalAng: float


#returns rotation val
func get_val():
	return finalAng

func _physics_process(delta: float) -> void:
	var mouseDist := get_global_mouse_position().distance_squared_to(knob.global_position)
	if mouseDist < MAX_DIST and Input.is_action_just_pressed("lmb"):
		following = true
	if Input.is_action_just_released("lmb"):
		following = false
		
		
	if following:
		var ang := get_global_mouse_position().angle_to_point( knob.global_position ) + -PI/2
		var d :Vector2= (knob_point.position.rotated( knob.rotation))
		var a = middle_point.position.angle_to(d)
		#var finalAng :float= remap( a, -3.14, 3.14, 0, 100 )
		finalAng = remap(knob.rotation, -2, 2, min_val, max_val)
		moved_dial.emit()
		var fang :float= lerp_angle( knob.rotation, ang, 0.3  )
		knob.rotation = clamp(fang, -2,2)
