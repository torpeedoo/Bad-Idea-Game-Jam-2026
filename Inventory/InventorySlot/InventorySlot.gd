extends Node2D
class_name InventorySlot

signal item_added

@export var item_storage_marker: Marker2D
@export var slot_area: Area2D

var item_stored: Node2D = null

func set_item(item: Node2D):
	item_stored = item
	item_added.emit()

func item_left():
	item_stored = null
