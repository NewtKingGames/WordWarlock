extends Node2D
class_name Keyboard

var keyboard_letter_scene: PackedScene = load("res://Scenes/ui/keyboard/keyboard_letter.tscn")
@onready var typing_noises: TypingNoises = $TypingNoises

@onready var letters: Node = $Letters
@onready var enter: KeyboardLetter = $SpecialKeys/Enter
@onready var spacebar: KeyboardLetter = $SpecialKeys/Spacebar
@onready var backspace: KeyboardLetter = $SpecialKeys/Backspace

var letter_dictionary = {}

var is_highlight_on: bool = false

func _ready():
	#visible = false
	modulate = Color(1,1,1,0)
	var letter_num = 0
	var keyboard_letters: Array[Node] = letters.get_children()
	for keyboard_letter in keyboard_letters:
		var letter: String = keyboard_letter.get_name().substr(keyboard_letter.get_name().length()-1)
		keyboard_letter.set_keyboard_letter(letter, letter_num)
		letter_num += 1
		letter_dictionary[letter] = keyboard_letter
	letter_dictionary["Enter"] = enter
	letter_dictionary["Backspace"] = spacebar
	letter_dictionary["Space"] = backspace
	Events.current_string_matches.connect(_on_current_string_matches)
	Events.current_string_typed.connect(_on_player_typed_string)
	
	

func _on_player_spell_key_pressed(letter_input: String):
	key_pressed(letter_input)

func _on_cast_spell_state_changed(is_casting_active: bool, typed_string, spell_scene):
	#visible = is_casting_active
	var tween = create_tween()
	if is_casting_active:
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.05)
	else:
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.2)

# Returns the letter the player pressed. Returns empty string "" if the key is disabled
func key_pressed(letter_input: String) -> String:
	if not letter_dictionary.has(letter_input):
		return ""
	
	typing_noises.play_typing_noise()
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


func _on_current_string_matches(string: String) -> void:
	is_highlight_on = true
	highlight_letter(enter)
	highlight_letter(spacebar)

func _on_player_typed_string(string: String) -> void:
	if is_highlight_on:
		enter.modulate = Color.WHITE
		spacebar.modulate = Color.WHITE
		is_highlight_on = false

func highlight_letter(keyboard_letter: KeyboardLetter) -> void:
	# TODO - make these effects nicer
	keyboard_letter.modulate = Color(0.93, 0.755, 0.149)
