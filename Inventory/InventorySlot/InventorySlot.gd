extends Node2D
class_name InventorySlot

signal item_added
signal item_removed

@export var item_storage_marker: Marker2D
@export var slot_area: Area2D
@export var background: Node

var item_stored: Node2D = null
var enabled: bool = true

func set_item(item: Node2D) -> bool:
	if !enabled or item_stored != null:
		return false
	
	enabled = false
	item_stored = item
	item_added.emit()
	return true
	

func item_left():
	enabled = true
	item_stored = null
	item_removed.emit()
