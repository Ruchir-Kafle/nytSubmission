extends Control

signal character_dialogue(character: String, text: String)
signal dialogue_finished()
@onready var characterText = get_node("characterText")
@onready var characterName = get_node("characterName")
@onready var textPanel = get_node("textPanel")
@onready var namePanel = get_node("namePanel")
@onready var typewriterTimer = get_node("typewriterTimer")

func _ready() -> void:
	emit_signal("character_dialogue", "placeholder", "placeholder")

func _on_character_dialogue(character, text) -> void:
	textPanel.visible = true
	namePanel.visible = true
	characterName.text = character
	characterText.text = text
	
	typewriterTimer.start()


func _on_typewriter_timer_timeout() -> void:
	characterText.visible_characters += 1
	
	if characterText.visible_ratio == 1:
		await get_tree().create_timer(1.5).timeout
		characterText.visible_characters = 0
		characterText.text = ""
		characterName.text = ""
		textPanel.visible = false
		namePanel.visible = false
		emit_signal("dialogue_finished")
	else:
		typewriterTimer.start()
