extends Node2D
class_name Keyboard

var keyboard_letter_scene: PackedScene = load("res://Scenes/ui/keyboard/keyboard_letter.tscn")

@onready var letters: Node = $Letters
var letter_dictionary = {}

func _ready():
	visible = false
	var letter_num = 0
	var keyboard_letters: Array[Node] = letters.get_children()
	for keyboard_letter in keyboard_letters:
		var letter: String = keyboard_letter.get_name().substr(keyboard_letter.get_name().length()-1)
		keyboard_letter.set_keyboard_letter(letter, letter_num)
		letter_num += 1
		letter_dictionary[letter] = keyboard_letter

func _on_player_spell_key_pressed(letter_input: String):
	key_pressed(letter_input)

func _on_cast_spell_state_changed(is_casting_active: bool, typed_string, spell_scene):
	visible = is_casting_active

# Returns the letter the player pressed. Returns empty string "" if the key is disabled
func key_pressed(letter_input: String) -> String:
	# TODO make sure this doesn't impact memory/performance
	var letter: KeyboardLetter = letter_dictionary[letter_input]
	if letter.letter_active:
		letter.key_pressed()
		return letter.letter_string
	else:
		return ""
