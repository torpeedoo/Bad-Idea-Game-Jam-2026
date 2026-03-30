extends Button
class_name MainMenuButton

@export var click_sfx: AudioStreamPlayer
@onready var hover_sfx = $/root/MainMenu/SFX/Hover

func _init():
	pressed.connect(play_click_sfx)
	mouse_entered.connect(play_hover_sfx)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func play_click_sfx():
	if click_sfx: click_sfx.play()

func play_hover_sfx():
	if !disabled:
		hover_sfx.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
