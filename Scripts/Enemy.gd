extends CharacterBody2D
class_name EnemyClass

@export var health: float
@export var walk_speed: float
var player: Player
# This relies on every enemy having a child node "StateMachine"
@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready():
	player = get_tree().get_first_node_in_group("player")

func hit(damage: float):
	health -= damage
	if health <= 0:
		state_machine.on_outside_transition("death")
	else:
		state_machine.on_outside_transition("damage")
