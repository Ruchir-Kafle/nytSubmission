extends Control

@onready var animationPlayer = get_node("AnimationPlayer")

var timing = false

func _process(_delta: float) -> void:
	if not timing:
		timing = true
		await get_tree().create_timer(randf() * 6 + 4).timeout
		animationPlayer.play("blink")
		timing = false
