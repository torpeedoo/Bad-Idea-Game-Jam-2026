extends Node

@export var seek_dial: Dial
@export var tune_dial: Dial
@export var freq_display: Label

var stations: Array

var frequency: float = 0.0

func _ready():
	if seek_dial:
		seek_dial.moved_dial.connect(update_freq)
	if tune_dial:
		tune_dial.moved_dial.connect(update_freq)

func load_stations():
	#TODO#
	#load stations from the level manager
	pass

func update_display():
	freq_display.text = str(snapped(frequency, 0.01))

func update_freq():
	frequency = floor(seek_dial.get_val()) + tune_dial.get_val()
	update_display()

func fade_stations():
	#TODO#
	#Not quite sure how to audios based on their station value yet.
	#Maybe remap station value to volume level for two closest stations?
	#Or find absolute distance from current frequency to closest two stations fo their volume level.
	pass
