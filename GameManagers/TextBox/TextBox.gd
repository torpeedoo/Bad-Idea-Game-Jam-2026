extends Node2D
class_name TextBox

signal chunk_done

@export var dialogue_res: DialogueRes
@export var dialogue_dict: Dictionary

@export var type_timer: Timer
@export var dialogue_control: Control
@export var dialogue_text: RichTextLabel
@export var name_label: Label
@export var speak_audio: AudioStreamPlayer
@export var click_audio: AudioStreamPlayer
@export var hover_audio: AudioStreamPlayer

@export var test:bool = false

var in_dialogue: bool = false

var current_chunk: DialogueChunk
var current_index: int = 0

var current_text: String = ""
var visible_characters: int = 0
var is_typing: bool = false


func _ready():
	if dialogue_control:
		dialogue_control.hide()
	
	type_timer.timeout.connect(_on_type_timer_timeout)
	
	if test and dialogue_res:
		load_dialogue_chunk("intro", false)

func _process(delta):
	if !in_dialogue: return
	
	if Input.is_action_just_pressed("lmb"):
		click_audio.play()
		display_next_dialogue()


# Load a dialogue chunk
func load_dialogue_chunk(key: String, pause: bool):
	if !dialogue_res.get_chunk(key): return
	
	if pause:
		get_tree().paused = true
	
	current_chunk = dialogue_res.get_chunk(key)
	current_index = 0
	
	show_dialogue_control()
	display_dialogue(current_index)


# Advance dialogue (call on click / input)
func display_next_dialogue():
	click_audio.play()
	
	# If typing, instantly finish line
	if is_typing:
		dialogue_text.text = current_text
		is_typing = false
		type_timer.stop()
		return
	
	current_index += 1
	
	if current_index >= current_chunk.line_array.size():
		end_dialogue()
	else:
		display_dialogue(current_index)


# Display a specific entry
func display_dialogue(index: int):
	if index < 0 or index >= current_chunk.line_array.size():
		return
	
	var entry = current_chunk.line_array[index]
	
	# Get text + name safely
	current_text = entry.text
	var speaker_name = entry.speaker
	
	# Update UI
	dialogue_text.text = ""
	name_label.text = speaker_name
	
	# Hide name if narration
	name_label.visible = speaker_name != ""
	
	visible_characters = 0
	is_typing = true
	
	type_timer.start()


# Typewriter effect
func _on_type_timer_timeout():
	if not is_typing:
		return
	
	visible_characters += 1
	dialogue_text.text = current_text.substr(0, visible_characters)
	if !speak_audio.playing: speak_audio.play()
	
	if visible_characters >= current_text.length():
		is_typing = false
		type_timer.stop()


func end_dialogue():
	current_chunk = null
	current_index = 0
	hide_dialogue_control()
	get_tree().paused = false 
	chunk_done.emit()


func show_dialogue_control():
	in_dialogue = true
	dialogue_control.show()


func hide_dialogue_control():
	in_dialogue = false
	dialogue_control.hide()
	dialogue_text.text = ""
	name_label.text = ""
	name_label.visible = false
