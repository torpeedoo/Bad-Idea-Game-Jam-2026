extends Node2D
class_name HandManager

@export var madness_level: int = 0
@export var open_hand_sprite: Sprite2D
@export var closed_hand_sprite: Sprite2D

var open: bool = true

func _init_hands():
	hide()
	open_hand_sprite.visible = open
	closed_hand_sprite.visible = !open

func open_hand():
	open_hand_sprite.show()
	closed_hand_sprite.hide()

func small_hand():
	pass

func close_hand():
	open_hand_sprite.hide()
	closed_hand_sprite.show()
