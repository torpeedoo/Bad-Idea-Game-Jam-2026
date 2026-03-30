extends Control
class_name TV

@export var sprite: AnimatedSprite2D
@export var audio: AudioStreamPlayer

func _ready():
	sprite.hide()

func play_static():
	sprite.show()
	sprite.play("Static")
	if audio: audio.play()

func stop_static():
	sprite.hide()
	if audio: audio.playing = false
