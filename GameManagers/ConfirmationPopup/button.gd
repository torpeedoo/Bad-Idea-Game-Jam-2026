extends Button

@export var hover_audio: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(hover_audio.play)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
