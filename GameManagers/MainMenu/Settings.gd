extends VBoxContainer

const AUDIO_BUSES: Array[String] = [
	"Radio",
	"Menu Music",
	"SFX",
]

const SETTINGS_SAVE_PATH: String = "user://settings.cfg"
const FONT_PATH: String = "res://Fonts/clacon2.ttf"

var _sliders: Dictionary = {}
var _config: ConfigFile
var _font: FontFile

func _ready() -> void:
	_font = load(FONT_PATH)
	_config = ConfigFile.new()
	_config.load(SETTINGS_SAVE_PATH)
	var idx = AudioServer.get_bus_index("Radio")
	AudioServer.set_bus_volume_db(idx, -20.0)
	_build_sliders()
	_load_settings()
	_move_back_button_to_bottom()

func _move_back_button_to_bottom() -> void:
	var back_button := $MarginContainer
	move_child(back_button, get_child_count() - 1)

func _build_sliders() -> void:
	for bus_name in AUDIO_BUSES:
		var row := HBoxContainer.new()
		row.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		var label := Label.new()
		label.text = bus_name
		label.add_theme_font_override("font", _font)
		label.add_theme_font_size_override("font_size", 30)
		label.custom_minimum_size.x = 120
		label.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		row.add_child(label)

		var slider := HSlider.new()
		
		var track_style := StyleBoxFlat.new()
		track_style.bg_color = Color(0.3, 0.3, 0.3)
		track_style.content_margin_top = 8.0 
		track_style.content_margin_bottom = 8.0 
		slider.add_theme_stylebox_override("slider", track_style)
		
		var filler_style := StyleBoxFlat.new()
		filler_style.bg_color = Color(0.8, 0.8, 0.8)
		filler_style.content_margin_top = 8.0
		filler_style.content_margin_bottom = 8.0
		slider.add_theme_stylebox_override("grabber_area", filler_style)
		
		slider.add_theme_constant_override("grabber_offset", 16)
		slider.min_value = 0.0
		slider.max_value = 1.0
		slider.step = 0.01
		slider.value = 1.0
		slider.custom_minimum_size.x = 200
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.size_flags_vertical = Control.SIZE_EXPAND_FILL
		slider.value_changed.connect(_on_slider_changed.bind(bus_name))
		row.add_child(slider)
		
		if bus_name == "Radio":
			slider.value = 40.0

		var percent_label := Label.new()
		percent_label.text = "100%"
		percent_label.add_theme_font_override("font", _font)
		percent_label.add_theme_font_size_override("font_size", 20)
		percent_label.custom_minimum_size.x = 45
		row.add_child(percent_label)

		_sliders[bus_name] = {"slider": slider, "label": percent_label}
		add_child(row)

func _on_slider_changed(value: float, bus_name: String) -> void:
	_sliders[bus_name]["label"].text = str(int(value * 100)) + "%"

	var db: float = linear_to_db(value) if value > 0.0 else -80.0
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, db)

	_save_settings()

func _load_settings() -> void:
	for bus_name in AUDIO_BUSES:
		var value: float = _config.get_value("audio", bus_name, 1.0)
		var slider_data: Dictionary = _sliders[bus_name]
		slider_data["slider"].value = value
		slider_data["label"].text = str(int(value * 100)) + "%"
		var db: float = linear_to_db(value) if value > 0.0 else -80.0
		var bus_index := AudioServer.get_bus_index(bus_name)
		if bus_index != -1:
			AudioServer.set_bus_volume_db(bus_index, db)

func _save_settings() -> void:
	for bus_name in AUDIO_BUSES:
		_config.set_value("audio", bus_name, _sliders[bus_name]["slider"].value)
	_config.save(SETTINGS_SAVE_PATH)
