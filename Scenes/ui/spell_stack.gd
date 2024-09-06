class_name SpellStack extends Node2D

const vertical_offset: int = -20
var spell_stack_word_scene: PackedScene  = preload("res://Scenes/ui/spell_stack_word.tscn")

# TODO - add the spell/effect here as something that should get executed

var spell_stack_word_strings: Array[String] = []
var spell_stack_word_children: Array[SpellStackWord] = []

# Test method
func _ready():
	var list_of_words: Array[String] = ["earl", "the", "pug"]
	set_stack_word_strings(list_of_words)


func _process(delta):
	# Going to do some testing
	if Input.is_key_pressed(KEY_R):
		on_player_casted_spell("earl")
		

# Let's say that the max amount of words that the max amount of words is 6 that means that max height is 120

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
		index += 1

func slide_spell_stack_word_positions():
	var index: int = 0
	for spell_stack_word_child in spell_stack_word_children:
		slide_spell_stack_word(spell_stack_word_children[index], generate_spell_stack_word_position(index))
		# TODO use some global variables at some point
		await get_tree().create_timer(0.25).timeout
		index += 1

func slide_spell_stack_word(spell_stack_word: SpellStackWord, position: Vector2):
	var tween_position: Tween = create_tween()
	tween_position.tween_property(spell_stack_word, "position", position, 0.5)

# Given the index of the word return the position the element should go
func generate_spell_stack_word_position(index: int) -> Vector2:
	return Vector2(0, index*vertical_offset)

func generate_spell_stack_word_opacity(index: int) -> float:
	return 0

func on_player_casted_spell(word: String):
	if word == spell_stack_word_children[0].word:
		pop_spell()
		
func pop_spell():
	var spell_stack_word: SpellStackWord = spell_stack_word_children.pop_front()
	spell_stack_word.queue_free()
	slide_spell_stack_word_positions()
	

func stack_emptied():
	print("stack emptied time to do something!!")
