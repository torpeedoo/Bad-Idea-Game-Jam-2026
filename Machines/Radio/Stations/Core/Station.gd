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
