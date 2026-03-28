extends MainMenuButton

@export var level_path: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(change_level)

func change_level():
	#maybe add a confirmation?
	
	Game_Manager.change_scene(level_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
