extends DraggableObject
class_name Tape
@export var freq_label: Label
@export var tape_sprite: Sprite2D
@export var pickup_sound: AudioStreamPlayer
@export var drop_sound: AudioStreamPlayer
@export var tape_record_time: float = 6.0
var recorded_song: Song = null
var recorded_duration: float
var recording_strendth: float

var normal_scale : Vector2
const HOVER_SCALE := Vector2(1.08, 1.08)
const TWEEN_DURATION := 0.15

func _ready():
	normal_scale = scale
	tape_sprite.use_parent_material = true
	in_recorder_area.connect(drag_ended_recorder)
	started_drag.connect(show_shadow)
	ended_drag.connect(hide_shadow)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	freq_label.text = "Blank Tape"
	super._ready()

func _on_mouse_entered():
	_tween_scale(HOVER_SCALE)

func _on_mouse_exited():
	_tween_scale(normal_scale)

func _tween_scale(target: Vector2):
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_scale", target, TWEEN_DURATION)

func show_shadow():
	pickup_sound.play()
	tape_sprite.show()
	freq_label.show()
	tape_sprite.use_parent_material = false
	global_scale = normal_scale

func hide_shadow():
	drop_sound.play()
	tape_sprite.use_parent_material = true
	global_scale = normal_scale

func is_song_anomaly():
	if recorded_song:
		return recorded_song.is_anomaly
	else:
		return false

func record_station(song: Song, recorded_dur: float, recording_str: float = 1.0):
	recorded_song = song
	recorded_duration = recorded_dur
	recording_strendth = recording_str
	if recorded_song:
		freq_label.text = str(recorded_song.song_name)
	else:
		freq_label.text = "Blank Tape"

func drag_ended_recorder(area: Area2D):
	var recorder: Recorder = area.get_parent().get_parent()
	if recorder.current_tape: return
	recorder.set_tape(self)
	move_object(recorder.tape_location_marker)
