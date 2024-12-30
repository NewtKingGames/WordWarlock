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
var highlight_tweens: Array[Tween] = []

# TODO - consider using a global variable for the players current typed word...
var length_current_string: int = 0
	

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
	letter_dictionary["ENTER"] = enter
	letter_dictionary["BACKSPACE"] = backspace
	letter_dictionary["SPACE"] = spacebar
	Events.current_string_matches.connect(_on_current_string_matches)
	Events.current_string_typed.connect(_on_player_typed_string)
	Events.player_exited_casting_state.connect(_on_casting_state_exited)

# This is where we change the visibllity
func _on_cast_spell_state_changed(is_casting_active: bool, typed_string, spell_scene):
	if is_casting_active:
		VisualUtils.fade_in_node(self, 0.05)
	else:
		VisualUtils.fade_out_node(self, 0.2)

# Returns the letter the player pressed. Returns empty string "" if the key is disabled
func key_pressed(letter_input: String) -> String:
	letter_input = letter_input.to_upper()
	if not letter_dictionary.has(letter_input):
		return ""
	typing_noises.play_typing_noise_pitch_modifier(Globals.current_player_typed_string.length())
	var letter: KeyboardLetter = letter_dictionary[letter_input]
	# key_pressed returns "" if the letter is inactive
	return letter.key_pressed()

func disable_random_key() -> KeyboardLetter:
	var letter_node: KeyboardLetter = get_random_active_key()
	letter_node.letter_active = false
	return letter_node

func freeze_random_key() -> KeyboardLetter:
	var letter_node: KeyboardLetter = get_random_unfrozen_key()
	letter_node.freeze_letter()
	return letter_node


func get_random_unfrozen_key() -> KeyboardLetter:
	# TODO - this is an infinite loop if somehow all keys are not active, that probably won't happen but probably should have some contingency
	while true:
		var random_letter_string: String = char(randi_range(65, 90))
		var letter_node: KeyboardLetter = letter_dictionary[random_letter_string]
		if not letter_node.letter_frozen:
			return letter_node
	# This is unexpected
	return null

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
	highlight_letters([enter, spacebar])
	#highlight_letter(spacebar)

func _on_player_typed_string(string: String) -> void:
	stop_highlight_letters()

func _on_casting_state_exited() -> void:
	stop_highlight_letters()

func stop_highlight_letters() -> void:
	if is_highlight_on:
		for tween in highlight_tweens:
			tween.kill()
			highlight_tweens = []
		enter.modulate = Color.WHITE
		spacebar.modulate = Color.WHITE
		enter.rotation = 0
		spacebar.rotation = 0
		is_highlight_on = false

# TODO - make these effects nicer
func highlight_letters(keyboard_letters: Array[KeyboardLetter]) -> void:
	for keyboard_letter in keyboard_letters:
		# think about moving the enter and spacebar characters here instead of flashing them yellow
		var highlight_tween: Tween = create_tween().set_loops()
		highlight_tween.tween_property(keyboard_letter, "modulate", Color(0.93, 0.755, 0.149), 0.5 * Engine.time_scale)
		highlight_tween.tween_property(keyboard_letter, "modulate", Color(1, 1, 1), 0.5 * Engine.time_scale)
		highlight_tweens.append(highlight_tween)
		#var rotate_tween: Tween = create_tween().set_loops()
		#rotate_tween.tween_property(keyboard_letter, "rotation", deg_to_rad(8), 0.75 * Engine.time_scale).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
		#rotate_tween.tween_property(keyboard_letter, "rotation", deg_to_rad(-8), 0.75 * Engine.time_scale).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
		#highlight_tweens.append(rotate_tween)
		#var scale_tween: Tween = create_tween().set_loops()
		#scale_tween.tween_property(keyboard_letter, "scale", Vector2(1.2, 1.2), 0.75 * Engine.time_scale).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		#scale_tween.tween_property(keyboard_letter, "scale", Vector2(0.9, 0.9), 1.25 * Engine.time_scale).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		#highlight_tweens.append(scale_tween)
	
	#keyboard_letter.modulate = Color(0.93, 0.755, 0.149)
