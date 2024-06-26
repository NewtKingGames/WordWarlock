extends Node

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.connect("spell_shot", _on_player_spell_shot)
	
func _on_player_spell_shot(spell_name: String):
	print("overall level casting spell")
	print(spell_name)
	

