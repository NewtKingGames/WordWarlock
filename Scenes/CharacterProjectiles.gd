extends Node


#Preloaded spells
var fireball_scene: PackedScene = preload("res://Scenes/projectiles/fireball.tscn")


var player: Player


func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.connect("spell_shot", _on_player_spell_shot)
	
func _on_player_spell_shot(spell_position: Vector2, spell_direction: Vector2, spell_name: String):
	print("overall level casting spell")
	print(spell_name)
	# it'd be great to have a way to make this spell spawning generic rather than if statements
	if spell_name == "FIREBALL":
		var spell: Fireball = fireball_scene.instantiate()
		spell.position = spell_position
		spell.rotation = spell_direction.angle()
		spell.direction = spell_direction
		self.add_child(spell)

