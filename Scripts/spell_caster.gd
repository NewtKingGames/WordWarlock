class_name SpellCaster
extends Node

# TODO - Pass the actual spell we cast rather than the string
signal spell_cast(spell_name: String)
signal spell_cast_node(spell_node: Spell)


# TODO see if you can get enums to work or define the enum in the spell as well to avoid hard coded strings?
enum Spells {FIREBALL, ICE_SHIELD, HASTE}
const CROSS_HAIR = preload("res://Sprites/v1.1 dungeon crawler 16X16 pixel pack/ui (new)/crosshair_3.png")

var known_spells_classes: Dictionary = {"FIREBALL": Fireball, "ICE SHIELD": IceShield, "THUNDERSTORM": Thunderstorm}
var known_spells_scenes: Dictionary = {
	"FIREBALL": load("res://Scenes/projectiles/fireball.tscn"),
 	"ICE SHIELD": load("res://Scenes/projectiles/ice_shield.tscn"),
 	"THUNDERSTORM": load("res://Scenes/projectiles/thunder_storm.tscn")
}

func _on_cast_cast_spell(spell_string):
	var spell: Spell = null
	match spell_string:
		"FIREBALL":
			spell = known_spells_scenes["FIREBALL"].instantiate()
			spell_cast.emit("FIREBALL")
		"ICE SHIELD": # facing anit pattern of having some spells spawned by the level while others should really just go to the player. Would it make sense to have the level add a child to the player node?
			spell = known_spells_scenes["ICE SHIELD"].instantiate()
			spell_cast.emit("ICE SHIELD")
		"THUNDERSTORM":
			spell = known_spells_scenes["THUNDERSTORM"].instantiate()
			spell_cast.emit("THUNDERSTORM")
		_:
			pass
	if spell != null:
		spell_cast_node.emit(spell)
		
func _on_cast_spell_node(spell_node):
	print("")

func is_string_known_spell(input: String):
	return known_spells_classes.has(input.to_upper())	

# Returns null if the spell is not known
func get_known_spell_for_string(input: String):
	if is_string_known_spell(input.to_upper()):
		return known_spells_classes[input.to_upper()]
	return null
