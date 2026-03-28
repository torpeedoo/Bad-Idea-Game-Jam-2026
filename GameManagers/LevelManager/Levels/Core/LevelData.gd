extends Resource
class_name LevelData

@export_category("Level Details")
@export var level_name: String = ""
@export var level_stations: Array[Station] = []
@export var anomaly_bounty: int = 10
@export var night_number: int = 0
@export var anomalies_pass_num: int = 0


func init_stations():
	for station in level_stations:
		station.init_station()

func hour_passed():
	for station in level_stations:
		station.hour_passed()
