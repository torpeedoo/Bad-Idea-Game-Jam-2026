extends Node2D
class_name JumpScare

signal scare_finished

@export var scare_img: TextureRect
@export var dither_img: ColorRect
@export var anim_player: AnimationPlayer

@export var stinger_audio: AudioStreamPlayer
@export var scream_audio: AudioStreamPlayer

@export var scare_on_screen_timer: Timer

func _ready():
	scare_img.hide()
	dither_img.hide()
	scare_on_screen_timer.timeout.connect(unscare)
	#scare()

func show_scare_img():
	anim_player.play("Scare")
	dither_img.show()
	scare_img.show()

func hide_scare_img():
	dither_img.hide()
	scare_img.hide()

func unscare():
	hide_scare_img()
	stinger_audio.playing = false
	scream_audio.playing = false
	scare_finished.emit()

func scare():
	stinger_audio.play()
	scream_audio.play()
	show_scare_img()
	scare_on_screen_timer.start()
