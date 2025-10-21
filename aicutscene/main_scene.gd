extends Node3D

@onready var dialogueNode = get_node("dialogue")
@onready var joe = get_node("joe")
@onready var joeAnimationPlayer = joe.get_node("joeAnimation")
@onready var blinkAnimationPlayer = get_node("blink").get_node("AnimationPlayer")
@onready var cameraAnimationPlayer = get_node("cameraAnimation")
@onready var camera = get_node("Camera3D")
@onready var characterText = dialogueNode.get_node("characterText")

enum characters {
	you,
	principal
}

enum joeAnimations {
	casual,
	sit,
	leaning,
	talking,
	still_talking,
	questioning
}

enum youAnimations {
	lookdown,
	lookup,
	shake
}

enum animationStates {
	pause = 20,
	play = 21
}

var counter = 0
var conversation = [
	[characters.principal, "{you}, I've been hearing reports from some of your teachers that you've been using AI to cheat on assignments", {characters.you: [youAnimations.lookup, 0.5], characters.principal: [joeAnimations.talking, 0]}],
	[characters.you, "... So what if I have?"],
	[characters.principal, "You do realize using AI to cheat is a major offense? And look, I like AI just as much as the next person. AI can be a very useful and helpful tool if used correctly.", {characters.principal: [animationStates.pause, 0.9]}],
	[characters.principal, "But that's if it's used correctly. Using it to do your work for you is a terrible way to use it, it's not constructive at all.", {characters.principal: [joeAnimations.leaning, 0]}],
	[characters.you, "... There's no point in doing these worthless assignments..."],
	[characters.principal, "Sorry? Could you speak loude-"],
	[characters.you, "I said there's no point in doing this work!! Why should I stress myself with this busy work if I can just... relax!", {characters.you: [youAnimations.shake, 0], characters.principal: [joeAnimations.questioning, 0]}],
	[characters.principal, "...", {characters.principal: [joeAnimations.casual, 0]}],
	[characters.principal, "What makes you think it's busy work?", {characters.principal: [joeAnimations.still_talking, 0]}],
	[characters.you, "There's just... no benefit. I don't want to write some essay.", {characters.principal: [animationStates.pause, 0.3]}],
	[characters.principal, "There's a point. Everything we have you do here is meant to prepare you for college and your life after.", {characters.you: [youAnimations.lookdown, 0.9], characters.principal: [joeAnimations.talking, 0]}],
	[characters.you, "Yeah but... uh... like...", {characters.principal: [animationStates.pause, 0]}],
	[characters.principal, "I know that you're more than capable of the work being asked of you.", {characters.principal: [joeAnimations.sit, 0]}],
	[characters.you, "..."],
	[characters.principal, "I'll give you... a week. In that time, I want you to rewrite the essay - by hand - and come back to me when you've finished. Are you fine with that?"],
	[characters.you, "... Yeah, alright."],
	[characters.principal, "Alright, make sure to get that done. I'm excited to see your work.", {characters.principal: [joeAnimations.casual, 0]}],
	[characters.you, "Alright, thanks mister."],
	[characters.principal, "Mhm."]
]
var animationsToPlay = []

func _ready() -> void:
	blinkAnimationPlayer.play("start")
	
	camera.rotation_degrees = Vector3(-75.6, -54.8, 46.5)
	
	characterText.visible_ratio = 0
	
	trigger_line()

func _process(_delta: float) -> void:
	run_animations()

func trigger_line():
	if len(conversation) > counter:
		var line = conversation[counter]
		dialogueNode.emit_signal("character_dialogue", characters.keys()[line[0]].capitalize(), line[1])
		
		if len(line) == 3:
			for animation in line[2].keys():
				animationsToPlay.append([animation, line[2][animation]])
	else:
		blinkAnimationPlayer.play("end")

func _on_dialogue_dialogue_finished() -> void:
	counter += 1
	trigger_line()


func run_animations():
	var clear = []
	var textVisibleRatio = characterText.visible_ratio
	
	for animation in animationsToPlay:
		var animationPlayer
		var characterEnum
		
		if textVisibleRatio >= animation[1][1]:
			if animation[0] == characters.you:
				animationPlayer = cameraAnimationPlayer
				characterEnum = youAnimations
			elif animation[0] == characters.principal:
				animationPlayer = joeAnimationPlayer
				characterEnum = joeAnimations
				
			if animation[1][0] == animationStates.pause:
				animationPlayer.pause()
			elif animation[1][0] == animationStates.play:
				animationPlayer.play()
			else:
				animationPlayer.play(characterEnum.keys()[animation[1][0]], 1.25)
	
			clear.append(animation)
	
	for removal in clear:
		animationsToPlay.erase(removal)
