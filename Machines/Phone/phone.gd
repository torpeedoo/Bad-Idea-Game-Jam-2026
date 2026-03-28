extends CustomButton
class_name Phone
@export var level_manager: LevelManager
@export var time_label: Label
@export var end_time_label: Label
@export var anomalies_found_label: Label
@export var anomalies_goal_label: Label
var anoms_found: int = 0

var normal_scale : Vector2
const HOVER_SCALE := Vector2(1.08, 1.08)
const TWEEN_DURATION := 0.15

func _ready():
	normal_scale = scale
	clicked.connect(_on_click)
	level_manager.hour_passed.connect(on_hour_pass)
	level_manager.anomaly_submitted.connect(anomaly_found)
	
	end_time_label.text = "End Time: "+str(level_manager.end_time)
	time_label.text = "Time: "+str(level_manager.start_time)
	anomalies_found_label.text = "Anom' Found: "+str(anoms_found)
	anomalies_goal_label.text = "Anom' Goal: "+str(level_manager.level_data.anomalies_pass_num)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	super._ready()

func anomaly_found():
	anoms_found += 1
	anomalies_found_label.text = "Anom' Found: "+str(anoms_found)

func on_hour_pass():
	time_label.text = "Time: "+str(level_manager.current_time)

func _on_mouse_entered():
	print("hi")
	_tween_scale(HOVER_SCALE)

func _on_mouse_exited():
	_tween_scale(normal_scale)

func _tween_scale(target: Vector2):
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", target, TWEEN_DURATION)

func _on_click():
	var popup = preload(Game_Manager.popup_path).instantiate()
	get_tree().current_scene.add_child(popup)
	
	popup.hide()
	popup.popup_text = "End night?"
	popup.set_label_text()
	popup.confirmed.connect(level_manager.end_level)
	popup.show()
	
	print("Popup shown")
