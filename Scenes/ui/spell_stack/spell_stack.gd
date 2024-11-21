class_name SpellStack extends Node2D

signal spell_stack_completed(SpellStack)

const vertical_offset: int = -20
# TODO - Having a real hard time getting this to work, see similar github issue: https://github.com/godotengine/godot/issues/20623
# The long short of it is, the label node's size doesnt' get update immediately after setting new text...
const horizontal_offset: int = 5
var spell_stack_word_scene: PackedScene  = preload("res://Scenes/ui/spell_stack/spell_stack_word.tscn")

var spell_stack_strings: Array[String] = []
var spell_stack_word_children: Array[SpellStackWord] = []
var spell: Spell

# TODO - refactor this as part of moving spells from nodes to resoureces
func init(spell: Spell) -> void:
	self.spell = spell
	# TODO - if you add the random words to the Spells themselves this would be easier
	#spell_stack_strings = GlobalSpells.known_spell_random_words[spell.spell_name]
	# For now keep all spells as one word
	spell_stack_strings = GlobalSpells.get_words_for_spell(spell, randi_range(1, 1))
	initialize_stack_word_children()


# Let's say that the max amount of words that the max amount of words is 6 that means that max height is 120

# creates spell_stack_word_children
func initialize_stack_word_children() -> void:
	# Delete any existing nodes because these are just test values
	for node in get_children():
		node.queue_free()
	#spell_stack_word_strings = words
	#for word in spell_stack_word_strings:
	for num in spell_stack_strings.size():
		# Instantiate a new spell_stack_word scene, add it to the array, and set the word
		var spell_stack_word_instance: SpellStackWord = spell_stack_word_scene.instantiate()
		spell_stack_word_children.push_back(spell_stack_word_instance)
		spell_stack_word_children[num].word = spell_stack_strings[num]
		add_child(spell_stack_word_instance)
	set_spell_stack_word_positions()
	

# TODO - Going to need to validate all of this visual code later. It's possible that it could all just be handled by it's children..

func set_spell_stack_word_positions():
	var index: int = 0
	for spell_stack_word_child in spell_stack_word_children:
		#spell_stack_word_child.position =  generate_spell_stack_word_position(index)
		spell_stack_word_child.position =  generate_spell_stack_word_position_horizontal(index)
		spell_stack_word_child.modulate = generate_spell_stack_word_opacity(index)
		index += 1

func slide_spell_stack_word_positions():
	var index: int = 0
	for spell_stack_word_child in spell_stack_word_children:
		slide_spell_stack_word(
			spell_stack_word_children[index], 
			#generate_spell_stack_word_position(index), 
			generate_spell_stack_word_position_horizontal(index),
			generate_spell_stack_word_opacity(index)
		)
		# TODO use some global variables at some point
		await get_tree().create_timer(0.25).timeout
		index += 1

func slide_spell_stack_word(spell_stack_word: SpellStackWord, position: Vector2, color: Color):
	var tween_position: Tween = create_tween()
	var tween_opacity: Tween = create_tween()
	tween_position.tween_property(spell_stack_word, "position", position, 0.5 * Globals.time_scale_offset)
	tween_opacity.tween_property(spell_stack_word, "modulate", color, 0.5 * Globals.time_scale_offset)

# Given the index of the word return the position the element should go
func generate_spell_stack_word_position(index: int) -> Vector2:
	print(spell_stack_word_children[index].position.x)
	return Vector2(spell_stack_word_children[index].position.x, index*vertical_offset)
	#return Vector2(index*horizontal_offset, spell_stack_word_children[index].position.y)

func generate_spell_stack_word_position_horizontal(index: int) -> Vector2:
	if index == 0:
		print("first word positiion")
		print(-spell_stack_word_children[index].size.x/2)
		return Vector2(-spell_stack_word_children[index].size.x/2, spell_stack_word_children[index].position.y)
	# Calculate x position
	var x_pos: float = spell_stack_word_children[index-1].size.x/2 + horizontal_offset
	print("this word positiion")
	print(x_pos)
	return Vector2(x_pos, spell_stack_word_children[index].position.y)

func generate_spell_stack_word_opacity(index: int) -> Color:
	var starting_color: Color = spell_stack_word_children[index].modulate
	# TODO convert 0.4 to some class level value
	return Color(starting_color.r, starting_color.g, starting_color.b, 1 - (0.4*index))
	
func on_player_typed_string(word: String) -> void:
	if word.to_upper() == spell_stack_word_children[0].word.to_upper():
		print("popping spell")
		pop_spell()

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
	tween_modulate.tween_property(word, "modulate", Color(1,1,1,0), 0.1*Globals.time_scale_offset).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween_position.tween_property(
		word,
		"position",
		word.position + Vector2(0, -vertical_offset),
	 	0.1*Globals.time_scale_offset
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).finished.connect(
		func():
			word.queue_free()
	)

func stack_emptied():
	print("stack emptied time to do something!!")
	# TODO - emit spell event? or let the parent do that?
	spell_stack_completed.emit(self)

func has_spell_stack() -> bool:
	return spell_stack_word_children.size() > 0
