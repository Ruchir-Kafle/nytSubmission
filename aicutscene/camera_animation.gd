extends AnimationPlayer

@export var camera: Camera3D

var max_shake_strength = 1
var shake_fade = 4
var shake_strength = 0

var rng = RandomNumberGenerator.new()

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		camera.h_offset = rng.randf_range(-shake_strength, shake_strength)
		camera.v_offset = rng.randf_range(-shake_strength, shake_strength)

func camera_shake():
	shake_strength = max_shake_strength
