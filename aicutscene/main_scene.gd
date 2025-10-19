extends Node3D

@onready var dialogueNode = get_node("dialogue")
@onready var joe = get_node("joe")
@onready var joeAnimationPlayer = joe.get_node("joeAnimation")
@onready var blinkAnimationPlayer = get_node("blink").get_node("AnimationPlayer")
@onready var cameraAnimationPlayer = get_node("cameraAnimation")
@onready var camera = get_node("Camera3D")

enum characters {
	you,
	principal
}

enum joeAnimations {
	casual,
	sit,
	leaning,
	talking,
	still_talking
}

enum youAnimations {
	lookdown,
	lookup
}

enum animationStates {
	pause = 20,
	play = 21
}

var counter = 0
var conversation = [
	[characters.principal, "{you}, I've been hearing reports from some of your teachers that you've been using AI to cheat on assignments"],
	[characters.you, "... So what if I have?"],
	[characters.principal, "You do realize using AI to cheat is a major offense? And look, I like AI just as much as the next person. AI can be a very useful and helpful tool if used correctly."],
	[characters.principal, "But that's if it's used correctly. Using it to do your work for you is a terrible way to use it, it's not constructive at all."],
	[characters.you, "... There's no point in doing these worthless assignments..."],
	[characters.principal, "Sorry? Could you speak loude-"],
	[characters.you, "I said there's no point in doing this work!! Why should I stress myself with this busy work if I can just... not!"],
	[characters.principal, "..."],
	[characters.principal, "What makes you think it's busy work?"],
	[characters.you, "There's just... no benefit. I don't want to write some essay."],
	[characters.principal, "There's a point. Everything we have you do here is meant to prepare you for college and your life after."],
	[characters.you, "Yeah but... uh... like..."],
	[characters.principal, "I know that you're more capable of the work being asked of you."],
	[characters.you, "..."],
	[characters.principal, "I'll give you... a week. In that time, I want you to rewrite the essay - by hand - and come back to me when you've finished. Are you fine with that?"],
	[characters.you, "... Yeah, alright."],
	[characters.principal, "Alright, make sure to get that done. I'm excited to see it!"],
	[characters.you, "Alright, thanks mister."],
	[characters.principal, "Mhm."]
]

func _ready() -> void:
	blinkAnimationPlayer.play("start")
	
	camera.rotation_degrees = Vector3(-75.6, -54.8, 46.5)
	
	var line = conversation[0]
	dialogueNode.emit_signal("character_dialogue", characters.keys()[line[0]].capitalize(), line[1])

func _on_dialogue_dialogue_finished() -> void:
	counter += 1
	if len(conversation) > counter:
		var line = conversation[counter]
		dialogueNode.emit_signal("character_dialogue", characters.keys()[line[0]].capitalize(), line[1])
		
		if len(line) > 2:
			if line[3] == animationStates.pause:
				if line[2] == characters.principal:
					joeAnimationPlayer.pause()
				elif line[2] == characters.you:
					cameraAnimationPlayer.pause()
			elif line[3] == animationStates.play:
				if line[2] == characters.principal:
					joeAnimationPlayer.play()
				elif line[2] == characters.you:
					cameraAnimationPlayer.play()
			else:
				if line[2] == characters.principal:
					joeAnimationPlayer.play(joeAnimations.keys()[line[3]], 1.25)
				elif line[2] == characters.you:
					cameraAnimationPlayer.play(youAnimations.keys()[line[3]], 1.25)
