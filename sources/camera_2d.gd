extends Camera2D

@export var RandomStrength: float = 15.0
@export var ShakeFade:float = 10.0

var rng = RandomNumberGenerator.new()

var shake_strenght: float = 0.0
var shake_mode: bool = false


func _ready() -> void:
	pass


func apply_shake() -> void:
	shake_strenght = RandomStrength


func _process(delta: float) -> void:

	if Input.is_action_just_pressed("ui_accept"):
		shake_mode = true

	if shake_mode:
		apply_shake()

	if shake_strenght > 0.1:
		shake_strenght = lerpf(shake_strenght, 0, ShakeFade * delta)
		offset = _random_offset()
		shake_mode = false


func _random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strenght, shake_strenght), rng.randf_range(-shake_strenght,shake_strenght))
