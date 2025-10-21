extends Control

@onready var animationPlayer = get_node("AnimationPlayer")

var timing = false
var blinking = true

func _process(_delta: float) -> void:
	if not timing:
		timing = true
		await get_tree().create_timer(randf() * 6 + 4).timeout
		if blinking:
			animationPlayer.play("blink")
			timing = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "end":
		blinking = false
