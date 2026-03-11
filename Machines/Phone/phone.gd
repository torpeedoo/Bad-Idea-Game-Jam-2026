extends CustomButton
class_name Phone

@export var level_manager: LevelManager

func _ready():
	clicked.connect(_on_click)
	super._ready()

func _on_click():
	if level_manager:
		level_manager.open_phone_menu()
