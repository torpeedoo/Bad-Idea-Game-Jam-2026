extends Button
class_name MainMenuButton

@export var click_sfx: AudioStreamPlayer

func _init():
	pressed.connect(play_click_sfx)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func play_click_sfx():
	if click_sfx: click_sfx.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
