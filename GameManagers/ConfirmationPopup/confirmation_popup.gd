extends Node2D
class_name ConfirmationPopup

signal confirmed
signal denied

@onready var confirm_button: Button = $CanvasLayer/Control/YesButton
@onready var deny_button: Button = $CanvasLayer/Control/NoButton
@onready var click_sound: AudioStreamPlayer = $ClickAudio
@onready var popup_text_label: Label = $CanvasLayer/Control/Label

var popup_text: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	confirm_button.pressed.connect(confirm)
	deny_button.pressed.connect(deny)
	get_tree().paused = true

func set_label_text():
	popup_text_label.text = popup_text

func confirm():
	get_tree().paused = false
	confirmed.emit()
	click_sound.play()
	
func deny():
	denied.emit()
	click_sound.play()
	delete_node()

func delete_node():
	get_tree().paused = false
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
