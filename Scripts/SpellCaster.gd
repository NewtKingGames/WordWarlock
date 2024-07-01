extends Node

# TODO - theres probably more information we want to emit, but this works for now
signal spell_cast(spell_name: String)

# TODO see if you can get enums to work or define the enum in the spell as well to avoid hard coded strings?
enum Spells {FIREBALL, ICE_SHIELD, HASTE}
const CROSS_HAIR = preload("res://Sprites/v1.1 dungeon crawler 16X16 pixel pack/ui (new)/crosshair_3.png")


func _on_cast_cast_spell(spell_string):
	print("Attempting to cast spell")
	print(spell_string)
	match spell_string:
		"FIREBALL":
			spell_cast.emit("FIREBALL")
		"ICE SHIELD": # facing anit pattern of having some spells spawned by the level while others should really just go to the player. Would it make sense to have the level add a child to the player node?
			spell_cast.emit("ICE SHIELD")
		_:
			print("default case")
