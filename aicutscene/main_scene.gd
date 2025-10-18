extends Node3D

@onready var dialogueNode = get_node("dialogue")
@onready var joe = get_node("joe")

enum characters {
	you,
	principal
}

enum animations {
	casual,
	sit,
	leaning
}

var counter = 0
var conversation = [
	[characters.principal, "{you}, I've heard that you've been using AI in your classes."],
	[characters.you, "..."],
	[characters.principal, "You do understand that this is a serious offense? Plagiarism is no joke!", animations.casual],
	[characters.you, "Yeah, yeah, yeah. I get it."],
	[characters.principal, "I don't think you do, since this is your second offense. The first time we were gracious in letting you redo the assignment, but if you're going to continue this behavior, we can't keep being lenient.", animations.sit],
	[characters.you, "..."],
	[characters.principal, "{you}.", animations.leaning],
	[characters.you, "..."],
	[characters.principal, "Hey, come on, I'm trying to help you."],
	[characters.you, "If you were trying to help me, you'd leave me alone."],
	[characters.principal, "That's not helpful. Plagiarism is a crime that you can be expelled for. We're trying to teach you that."],
	[characters.you, "Yeah right. Just shut up."],
	[characters.principal, "..."],
	[characters.principal, "Is that all you have to say for yourself?"],
	[characters.you, "..."],
	[characters.principal, "Well, if you're not going to cooperate with me, you leave me no choice but to expel you."],
	[characters.you, "Huh?"],
	[characters.principal, "It seems this is the only way to teach you a lesson."],
	[characters.you, "Wait... you can't do that though."],
	[characters.principal, "I just did. Now get out of my sight."]
]

func _ready() -> void:
	var line = conversation[0]
	dialogueNode.emit_signal("character_dialogue", characters.keys()[line[0]].capitalize(), line[1])

func _on_dialogue_dialogue_finished() -> void:
	counter += 1
	if len(conversation) > counter:
		var line = conversation[counter]
		dialogueNode.emit_signal("character_dialogue", characters.keys()[line[0]].capitalize(), line[1])
		
		if len(line) > 2:
			joe.get_node("joeAnimation").play(animations.keys()[line[2]])
