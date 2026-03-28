extends MainMenuButton


@export var menu_manager: MainMenuManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(menu_manager.go_back)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
