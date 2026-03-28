extends Node
class_name TapeDispenser

@export_category("Params")
@export var current_tapes: int = 3

@export_category("Refs")
@export var inventory_slot: InventorySlot
@export var tape_box_sprite: Sprite2D
@export var tape_sprites: Array[Sprite2D] = []
@export var tape_scene: PackedScene

func _ready():
	spawn_tape()
	update_tape_sprites()
	inventory_slot.background.hide()
	inventory_slot.item_removed.connect(tape_taken)

func tape_taken():
	if current_tapes > 0:
		spawn_tape()
		update_tape_sprites()

func spawn_tape():
	current_tapes -= 1
	
	var tape: Tape = tape_scene.instantiate()
	inventory_slot.item_storage_marker.add_child(tape)
	inventory_slot.set_item(tape)
	inventory_slot.enabled = false
	tape.current_inv_slot = inventory_slot

func update_tape_sprites():
	for i in range(tape_sprites.size()):
		if i < current_tapes:
			tape_sprites[i].show()
		else:
			tape_sprites[i].hide()
