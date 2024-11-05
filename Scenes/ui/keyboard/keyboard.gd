extends Node2D
class_name Keyboard

var keyboard_letter_scene: PackedScene = load("res://Scenes/ui/keyboard/keyboard_letter.tscn")
@onready var typing_noises: Node2D = $TypingNoises

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
	letter_dictionary["Enter"] = $SpecialKeys/Enter
	letter_dictionary["Backspace"] = $SpecialKeys/Backspace
	letter_dictionary["Space"] = $SpecialKeys/Spacebar
	
	

func _on_player_spell_key_pressed(letter_input: String):
	key_pressed(letter_input)

func _on_cast_spell_state_changed(is_casting_active: bool, typed_string, spell_scene):
	visible = is_casting_active

# Returns the letter the player pressed. Returns empty string "" if the key is disabled
func key_pressed(letter_input: String) -> String:
	var typing_noise_index: int = randi_range(0, typing_noises.get_child_count()-1)
	typing_noises.get_child(typing_noise_index).pitch_scale = randf_range(.9, 1.05)
	typing_noises.get_child(typing_noise_index).play()
	var letter: KeyboardLetter = letter_dictionary[letter_input]
	if letter.letter_active:
		letter.key_pressed()
		return letter.letter_string
	else:
		return ""

func disable_random_key() -> KeyboardLetter:
	# TODO randomize this later
	var letter_node: KeyboardLetter = get_random_active_key()
	letter_node.letter_active = false
	return letter_node

func get_random_active_key() -> KeyboardLetter:
	# TODO - this is an infinite loop if somehow all keys are not active, that probably won't happen but probably should have some contingency
	while true:
		var random_letter_string: String = char(randi_range(65, 90))
		var letter_node: KeyboardLetter = letter_dictionary[random_letter_string]
		if letter_node.letter_active:
			return letter_node
	# This is unexpected
	return null
