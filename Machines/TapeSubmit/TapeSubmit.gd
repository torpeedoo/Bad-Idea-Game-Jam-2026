extends InventorySlot

@export var level_manager: LevelManager
@export var bay_full: Sprite2D
@export var bay_empty: Sprite2D
@export var screen_on: Sprite2D
@export var screen_off: Sprite2D
@export var screen_anim: AnimatedSprite2D
@export var tape_enter_audio: AudioStreamPlayer
@export var success_audio: AudioStreamPlayer
@export var fail_audio: AudioStreamPlayer

var screen_anim_playing: bool = false
var anim_queue: Array[String] = []

func _ready():
	item_added.connect(_item_added)
	screen_anim.animation_finished.connect(anim_over)
	play_anim("Startup")

func play_anim(anim_name: String):
	anim_queue.append(anim_name)

	if !screen_anim_playing:
		start_next_anim()

func start_next_anim():
	if anim_queue.is_empty():
		screen_anim.hide()
		screen_on.show()
		screen_anim_playing = false
		return

	screen_anim_playing = true
	screen_anim.show()
	screen_on.hide()

	var next_anim = anim_queue.pop_front()
	if next_anim == "Success":
		_delete_tape()
		success_audio.play()
	elif next_anim == "Fail":
		_delete_tape()
		fail_audio.play()
	elif next_anim == "Analyzing":
		slot_area.hide()
	screen_anim.play(next_anim)

func anim_over():
	start_next_anim()

func analyze_tape(tape: Tape):
	play_anim("Analyzing")
	
	if tape.is_song_anomaly() and tape.recorded_song not in level_manager.anomalies_recorded:
		level_manager.anomaly_submitted.emit()
		play_anim("Success")
		level_manager.anomalies_recorded.append(tape.recorded_song)
		add_anomaly_success()
	else:
		play_anim("Fail")
		
	enabled = true

func add_anomaly_success():
	level_manager.anomalies_found += 1

func _delete_tape():
	item_stored.queue_free()
	slot_area.show()
	item_stored = null
	bay_full.hide()
	bay_empty.show()

func _item_added():
	if item_stored is Tape:
		var tape_stored: Tape = item_stored
		
		tape_enter_audio.play()
		item_stored.hide()
		bay_empty.hide()
		bay_full.show()
		
		analyze_tape(tape_stored)
