extends Node

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.connect("spell_shot", _on_player_spell_shot)

func _on_player_spell_shot(spell: Spell):
	if is_instance_of(spell, IceShield): # Some spells spawn on the player
		player.add_child(spell)
	else:
		self.add_child(spell)
	
