extends Control
class_name InventoryUI

@export var open_button: TextureButton
@export var open_button_sprite: Sprite2D
@export var close_button: TextureButton
@export var inventory_base: Control
@export var level_manager: LevelManager
@export var interaction_audio: AudioStreamPlayer
@export var shadowman: ShadowMan
@export var anim_player: AnimationPlayer

@export var inv_slots: Array[InventorySlot]
@export var init_items: Array[PackedScene]

@export var inhaler_uses: int = 1
@export var tapes: int = 2

var inv_open: bool = false
var slots_enabled: bool = false
var jumpscare_active: bool = false

func _ready():
	_init_slots()
	update_slots()
	
	if open_button:
		open_button.pressed.connect(_open_inv)
	if close_button:
		close_button.pressed.connect(_close_inv)

func activate_scare():
	if inv_open: return
	
	anim_player.play("Transition")
	jumpscare_active = true

func deactivate_scare():
	anim_player.play_backwards("Transition")
	jumpscare_active = false

func _init_slots():
	for slot in inv_slots:
		var item = init_items.pop_front()
		if item:
			var item_node = item.instantiate()
			slot.item_storage_marker.add_child(item_node)
			if item_node is Inhaler and level_manager:
				item_node.level_manager = level_manager
				item_node.set_uses(inhaler_uses)
			if item_node is TapeDispenser:
				item_node.current_tapes = tapes
				item_node.update_tape_sprites()
			slot.set_item(item_node)

func update_slots():
	for slot in inv_slots:
		slot.enabled = slots_enabled

func _open_inv():
	if inv_open: return
	
	if jumpscare_active:
		interaction_audio.play()
		shadowman.trigger_scare()
	else:
		slots_enabled = true
		inv_open = true
		open_button.hide()
		open_button_sprite.hide()
		inventory_base.show()
		interaction_audio.play()
		update_slots()

func _close_inv():
	if !inv_open: return
	
	slots_enabled = false
	inv_open = false
	open_button.show()
	open_button_sprite.show()
	inventory_base.hide()
	interaction_audio.play()
	update_slots()
