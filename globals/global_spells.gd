extends Node

# Spells used for enemy shield bubbles
var enemy_spell_shield_words: Array[String] = ["Disarm", "Pierce", "Break", "Shatter", "Dismantle", "Destroy", "Demolish", "Relinquish"]

# TODO see if you can get enums to work or define the enum in the spell as well to avoid hard coded strings?
enum Spells {FIREBALL, ICE_SHIELD, HASTE}

var known_spells_classes: Dictionary = {"FIREBALL": Fireball, "ICE SHIELD": IceShield, "THUNDERSTORM": Thunderstorm, "HASTE": Haste}
var known_spells_scenes: Dictionary = {
	"FIREBALL": load("res://Scenes/projectiles/fireball.tscn"),
 	"ICE SHIELD": load("res://Scenes/projectiles/ice_shield.tscn"),
 	"THUNDERSTORM": load("res://Scenes/projectiles/thunder_storm.tscn"),
	"HASTE": load("res://Scenes/projectiles/haste_spell.tscn")
}

# Retruns a packed scene for a spell or null
func get_spell_scene_for_string(spell_string) -> Object:
	if known_spells_scenes.has(spell_string):
		return known_spells_scenes[spell_string]
	return null
	#match spell_string:
		#"FIREBALL":
			#spell = known_spells_scenes["FIREBALL"]
		#"ICE SHIELD":
			#spell = known_spells_scenes["ICE SHIELD"]
		#"THUNDERSTORM":
			#spell = known_spells_scenes["THUNDERSTORM"]
		#""
		#_:
			#pass
	#return spell

func is_string_known_spell(input: String) -> bool:
	return known_spells_classes.has(input.to_upper())	

# Returns null if the spell is not known
func get_known_spell_for_string(input: String) -> Object:
	if is_string_known_spell(input.to_upper()):
		return known_spells_classes[input.to_upper()]
	return null
