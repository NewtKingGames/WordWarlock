extends CharacterBody2D
class_name EnemyClass

@export var health: float
@export var speed: float
var player: Player
# This relies on every enemy having a child node "StateMachine"
@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready():
	player = get_tree().get_first_node_in_group("player")

func hit(damage: float):
	print("the enemy is hit!!")
	state_machine.on_outside_transition("damage")
