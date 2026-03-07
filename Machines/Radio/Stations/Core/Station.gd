extends Resource
class_name Station

@export var station_name: String
@export var station_freq: float
@export_range(0.0, 1, 0.1) var bandwith
enum AM_FM {AM, FM}
@export var am_fm: AM_FM = AM_FM.FM
@export var current_song: AudioStream
@export var song_list: Array[AudioStream]
@export var broadcasting: bool = true

var current_song_index: int = 0

func init_station():
	broadcasting = true
	current_song_index = 0
	current_song = song_list.get(current_song_index)

func hour_passed():
	current_song_index += 1
	current_song = song_list.get(current_song_index)
