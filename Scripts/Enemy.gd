extends CharacterBody2D
class_name EnemyClass

@export var health: float
@export var speed: float
var player: Player


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	print("found player")
	print(player)
