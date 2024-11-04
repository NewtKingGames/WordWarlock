extends Node2D

signal player_equipped_spell
# TODO - you could think about a fun way of letting the player auto cycle through their spells?
# TODO - this is really gross right now because spells are a node and not a resource....
@export var available_spells: Array[String] = []

# TODO - need to make sure this get's initialized correctly
@export var equipped_spell: String
var equipped_index: int = 0


func _process(delta: float) -> void:
	# Only allow changing spells if the player is not casting
	if Globals.is_player_casting:
		return
	if Input.is_action_just_pressed("equip_spell_one"):
		equip_spell(0)
	if Input.is_action_just_pressed("equip_spell_two"):
		equip_spell(1)
	if Input.is_action_just_pressed("equip_spell_three"):
		equip_spell(2)
	if Input.is_action_just_pressed("equip_spell_four"):
		equip_spell(3)


func equip_spell(index: int) -> void:
	equipped_index = index
	equipped_spell = available_spells[index]
	player_equipped_spell.emit()

