extends Node

# TODO see if you can get spells to work
enum Spells {FIREBALL, ICE, HASTE}

func _on_cast_cast_spell(spell_string):
	print("Attempting to cast spell")
	print(spell_string)
	match spell_string:
		"FIREBALL":
			print("casting fireball")
		"ICE":
			print("casting ice")
		_:
			print("default case")
	
