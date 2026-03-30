extends Control
class_name ShadowMan

@export var anim: AnimatedSprite2D
@export var scare_sound: AudioStreamPlayer
@export var inv_ui: InventoryUI
@export var death_timer: Timer

func _ready():
	hide()
	if death_timer:
		death_timer.timeout.connect(reset_level)
	if anim:
		anim.animation_finished.connect(death_timer.start)
	

func _process(delta):
	if anim.is_playing():
		if anim.frame == 14:
			scare_sound.play()

func reset_level():
	inv_ui.level_manager.reload_scene()

func trigger_scare():
	anim.play("Scare")
