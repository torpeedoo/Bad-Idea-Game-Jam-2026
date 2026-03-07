extends Resource
class_name LevelData

@export_category("Level Details")
@export var level_name: String = ""
@export var level_stations: Array[Station] = []
@export var anomaly_stations: Array[Station] = []

func init_stations():
	for station in level_stations + anomaly_stations:
		station.init_station()

func hour_passed():
	for station in level_stations + anomaly_stations:
		station.hour_passed()
