extends Node
class_name TurorialManager

@export var tutorial_enabled: bool = false
@export var text_box: TextBox
@export var level_manager: LevelManager

var anomalies_found: int = 0
var anomaly_been_recorded: bool = false
var anomalies_been_submitted: int = 0

func _ready():
	if !tutorial_enabled:
		queue_free()
	
	if level_manager:
		level_manager.anomaly_found.connect(anomaly_found)
		level_manager.anomaly_recorded.connect(anomaly_recorded)
		level_manager.anomaly_submitted.connect(anomaly_submitted)
	
	play_intro()

func anomaly_submitted():
	if anomalies_been_submitted > 2: return
	
	anomalies_been_submitted += 1
	
	if anomalies_been_submitted == 1:
		pass
		#text_box.load_dialogue_chunk("anomaly_submitted", true)
	elif anomalies_been_submitted == 2:
		text_box.load_dialogue_chunk("second_anomaly_found", true)

func anomaly_recorded():
	if anomaly_been_recorded: return
	
	anomaly_been_recorded = true
	text_box.load_dialogue_chunk("anomaly_recorded", true)

func anomaly_found():
	if anomalies_found > 1: return
	
	anomalies_found += 1
	
	if anomalies_found == 1:
		text_box.load_dialogue_chunk("anomaly_found", true)


func play_intro():
	text_box.load_dialogue_chunk("intro", false)
