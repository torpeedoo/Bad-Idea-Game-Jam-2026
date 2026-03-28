extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

var _target: String = ""
var _transitioning: bool = false

func _ready() -> void:
	_target = Game_Manager.get_target_scene()
	ResourceLoader.load_threaded_request(_target)

func _process(_delta: float) -> void:
	if _transitioning:
		return
	var progress := []
	var status := ResourceLoader.load_threaded_get_status(_target, progress)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100
		ResourceLoader.THREAD_LOAD_LOADED:
			_transitioning = true
			set_process(false)
			progress_bar.value = 100
			var scene: PackedScene = ResourceLoader.load_threaded_get(_target)
			await Game_Manager._dither_in()
			get_tree().change_scene_to_packed.call_deferred(scene)
			await Game_Manager._dither_out()
		ResourceLoader.THREAD_LOAD_FAILED:
			push_error("LoadingScreen: failed to load " + _target)
