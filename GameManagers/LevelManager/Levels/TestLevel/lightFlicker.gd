extends PointLight2D

@export var base_energy: float = 1.0
@export var flicker_strength: float = 0.1
@export var flicker_speed: float = 2.0

var noise := FastNoiseLite.new()
var time := 0.0

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 1.0

func _process(delta):
	time += delta * flicker_speed
	var n = noise.get_noise_1d(time)
	energy = base_energy + (n * flicker_strength)
