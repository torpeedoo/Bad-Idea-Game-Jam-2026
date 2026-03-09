extends InventorySlot

@export var level_manager: LevelManager

func _ready():
	item_added.connect(_item_added)
	
func _item_added():
	if item_stored is Tape:
		var tape_stored: Tape = item_stored
		var tape_station = tape_stored.recorded_station
		
		if tape_station in level_manager.get_anomaly_stations():
			print("station recorded correct")
		else:
			print("station recorded false")
