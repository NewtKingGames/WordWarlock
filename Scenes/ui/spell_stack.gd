class_name SpellStack extends Node2D

const vertical_offset: int = -20
var spell_stack_word_scene: PackedScene  = preload("res://Scenes/ui/spell_stack_word.tscn")

# TODOs:
# 1. add this to the player
# 2. figure out how to attach signals properly
# 3. figure out how to do the final stack execution
# 4. figure out how to dynamically populate this class with spell words
#    a. Maybe another global array per spell word?
# 5. figure out how a player is going to equip a spell
# 6. figure out how visible this property needs to be... Should it disappear after a bit after the player stops casting

# TODO - add the spell/effect here as something that should get executed

var spell_stack_word_strings: Array[String] = []
var spell_stack_word_children: Array[SpellStackWord] = []

# Test method
func _ready():
	var list_of_words: Array[String] = ["burn", "ember", "flame"]
	set_stack_word_strings(list_of_words)


func _process(delta):
	# Going to do some testing
	if Input.is_action_just_pressed("backspace"):
		on_player_casted_spell(spell_stack_word_children[0].word)

# Let's say that the max amount of words that the max amount of words is 6 that means that max height is 120

# Should be called initially when creating the object
func set_stack_word_strings(words: Array[String]):
	spell_stack_word_strings = words
	#for word in spell_stack_word_strings:
	for num in spell_stack_word_strings.size():
		# Instantiate a new spell_stack_word scene, add it to the array, and set the word
		var spell_stack_word_instance: SpellStackWord = spell_stack_word_scene.instantiate()
		spell_stack_word_children.push_back(spell_stack_word_instance)
		spell_stack_word_children[num].word = words[num]
		add_child(spell_stack_word_instance)
	set_spell_stack_word_positions()
	

func set_spell_stack_word_positions():
	var index: int = 0
	for spell_stack_word_child in spell_stack_word_children:
		spell_stack_word_child.position = generate_spell_stack_word_position(index)
		spell_stack_word_child.modulate = generate_spell_stack_word_opacity(index)
		index += 1

func slide_spell_stack_word_positions():
	var index: int = 0
	for spell_stack_word_child in spell_stack_word_children:
		slide_spell_stack_word(
			spell_stack_word_children[index], 
			generate_spell_stack_word_position(index), 
			generate_spell_stack_word_opacity(index)
		)
		# TODO use some global variables at some point
		await get_tree().create_timer(0.25).timeout
		index += 1

func slide_spell_stack_word(spell_stack_word: SpellStackWord, position: Vector2, color: Color):
	var tween_position: Tween = create_tween()
	var tween_opacity: Tween = create_tween()
	tween_position.tween_property(spell_stack_word, "position", position, 0.5)
	tween_opacity.tween_property(spell_stack_word, "modulate", color, 0.5)

# Given the index of the word return the position the element should go
func generate_spell_stack_word_position(index: int) -> Vector2:
	return Vector2(0, index*vertical_offset)

func generate_spell_stack_word_opacity(index: int) -> Color:
	var starting_color: Color = spell_stack_word_children[index].modulate
	# TODO convert 0.4 to some class level value
	return Color(starting_color.r, starting_color.g, starting_color.b, 1 - (0.4*index))

func on_player_casted_spell(word: String):
	if word == spell_stack_word_children[0].word:
		pop_spell()
	# TODO - add some spell miss?

func pop_spell():
	var spell_stack_word: SpellStackWord = spell_stack_word_children.pop_front()
	spell_popped_effect(spell_stack_word)
	if spell_stack_word_children.size() == 0:
		stack_emptied()
	else:
		slide_spell_stack_word_positions()

func spell_popped_effect(word: SpellStackWord):
	var tween_position: Tween = create_tween()
	var tween_modulate: Tween = create_tween()
	tween_modulate.tween_property(word, "modulate", Color(1,1,1,0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	await tween_position.tween_property(
		word,
		"position",
		word.position + Vector2(0, 20),
	 	0.25
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).finished
	word.queue_free()

func stack_emptied():
	print("stack emptied time to do something!!")
