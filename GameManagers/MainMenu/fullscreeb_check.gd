extends CheckBox

var is_fullscreen: bool = false

func _ready():
	if DisplayServer.window_get_mode() == 3:
		is_fullscreen = true
	else:
		is_fullscreen = false
	
	pressed.connect(fullscreen_toggle)
	
	if OS.has_feature("web"):
		hide()

func fullscreen_toggle():
	print("toggle")
	if !is_fullscreen:
		is_fullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		is_fullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _process(delta):
	pass
