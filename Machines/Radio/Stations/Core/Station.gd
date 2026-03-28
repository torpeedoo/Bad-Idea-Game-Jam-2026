extends Resource
class_name Station

@export var station_name: String
@export var station_freq: float
@export_range(0.0, 1, 0.1) var bandwith = 0.7
enum AM_FM {AM, FM}
@export var am_fm: AM_FM = AM_FM.FM
@export var current_song: Song
@export var song_list: Array[Song]
@export var broadcasting: bool = true
@export var random_anomalies: bool

var current_song_index: int = 0


func init_station():
	init_songs()
	broadcasting = true
	current_song_index = 0
	current_song = song_list.pick_random()

func init_songs():
	for song in song_list:
		song.init_song(random_anomalies)

func hour_passed():
	current_song_index += 1
	current_song = song_list.pick_random()
