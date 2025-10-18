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
	[characters.principal, "hey ruchir, how are you doing on this very fine day today?"],
	[characters.you, "absolutely terrible. im apalled that you would even dare to ask.", animations.casual]
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
