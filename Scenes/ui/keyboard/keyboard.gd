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

func _on_player_enter_cast_state():
	visible = true
	
func _on_player_exit_cast_state():
	visible = false

# Returns the letter the player pressed. Returns empty string "" if the key is disabled
func key_pressed(letter_input: String) -> String:
	# TODO make sure this doesn't impact memory/performance
	var letter: KeyboardLetter = letter_dictionary[letter_input]
	if letter.letter_active:
		print("active?")
		letter.key_pressed()
		return letter.letter_string
	else:
		print("inactive")
		return ""
