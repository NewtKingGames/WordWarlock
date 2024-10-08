extends Node2D

# script to connect logic from the player spell to the spell stack
# this script is meant to be a child of the player so I'm fine with this
@onready var player = $".."
@onready var spell_stack: SpellStack = $SpellStack

# This class will need to know:
# 1. if the player is casting or not
# 2. which spell the player is trying to equip
# 3. The random words that can be selected  
# 4. if the spell stack has random words already
# 5. the spell that should go with the spell words


func _ready():
	$"../StateMachine/Cast".connect("cast_spell_state_changed", _on_player_casted_spell)

func _process(delta):
	if not player.is_player_casting and not spell_stack.has_spell_stack():
		if Input.is_action_just_pressed("equip_spell_one"):
			spell_stack.set_stack_word_strings(create_random_word_array_for_spell("FIREBALL"))


func _on_player_casted_spell(is_state_active: bool, string_typed, spell_scene):
	if string_typed is String and spell_stack.has_spell_stack():
		spell_stack.on_player_casted_spell(string_typed)

func create_random_word_array_for_spell(spell_name: String) -> Array[String]:
	var num_words: int = randi_range(1, 3)
	var words: Array[String] = []
	for num in num_words:
		words.push_back(GlobalSpells.known_spell_random_words[spell_name.to_upper()].pick_random())
	return words
