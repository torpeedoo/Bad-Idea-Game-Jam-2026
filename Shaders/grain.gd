extends ColorRect
class_name Grain

@export var grain_shader: ShaderMaterial

func _ready():
	grain_shader.set_shader_parameter("noise_intensity", 0.0)

func change_grain_str(str: float):
	grain_shader.set_shader_parameter("noise_intensity", str*0.7)
