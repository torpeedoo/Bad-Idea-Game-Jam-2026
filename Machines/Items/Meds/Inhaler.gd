extends CustomButton
class_name Inhaler
@export var anim_player: AnimationPlayer
@export var level_manager: LevelManager
@export var count_sprite: Sprite2D
@export var madness_reduction: float
@export var x_pos_counts: Array[float]
var y_pos_counts: float = 313.854
var uses: int

const NORMAL_SCALE := Vector2(1.0, 1.0)
const HOVER_SCALE := Vector2(1.08, 1.08)
const TWEEN_DURATION := 0.15

func _ready():
	clicked.connect(on_use)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	super._ready()

func set_uses(amt: int):
	uses = amt
	set_uses_sprite(uses)

func set_uses_sprite(amt: int):
	count_sprite.texture.region.position.x = x_pos_counts.get(amt)

func _on_mouse_entered():
	_tween_scale(HOVER_SCALE)

func _on_mouse_exited():
	_tween_scale(NORMAL_SCALE)

func _tween_scale(target: Vector2):
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", target, TWEEN_DURATION)

func on_use():
	if uses <= 0: return
	anim_player.play("use")

func move_count():
	pass

func reduce_madness():
	if level_manager:
		level_manager.reduce_madness(madness_reduction)
		uses -= 1
		set_uses_sprite(uses)
