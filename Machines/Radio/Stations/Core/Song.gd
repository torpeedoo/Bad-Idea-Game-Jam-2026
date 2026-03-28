extends Resource
class_name Song

@export var normal_audiostream: AudioStream
@export var anomaly_audiostream: AudioStream
@export var is_anomaly: bool
@export var song_name: String

@export_range(0.0, 1.0, 0.1) var anomaly_chance = 0.5

var audiostream: AudioStream

func init_song(random: bool):
	
	if random:
		roll_anomaly()
	else:
		if is_anomaly: audiostream = anomaly_audiostream
		elif !is_anomaly: audiostream = normal_audiostream

func roll_anomaly():
	if randf() > anomaly_chance:
		is_anomaly = true
		audiostream = anomaly_audiostream
	else:
		is_anomaly = false
		audiostream = normal_audiostream
