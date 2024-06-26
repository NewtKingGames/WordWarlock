extends Node

# TODO - theres probably more information we want to emit, but this works for now
signal spell_cast(spell_name: String)

# TODO see if you can get spells to work
enum Spells {FIREBALL, ICE, HASTE}
const CROSS_HAIR = preload("res://Sprites/v1.1 dungeon crawler 16X16 pixel pack/ui (new)/crosshair_3.png")


func _on_cast_cast_spell(spell_string):
	print("Attempting to cast spell")
	print(spell_string)
	match spell_string:
		"FIREBALL":
			spell_cast.emit("FIREBALL")
		"ICE":
			spell_cast.emit("ICE")
		_:
			print("default case")
