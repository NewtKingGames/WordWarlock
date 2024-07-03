extends CharacterBody2D
class_name EnemyClass

@export var health: float
@export var walk_speed: float
@export var chase_distance: float
var player: Player
# This relies on every enemy having a child node "StateMachine"
@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite_2d: AnimationPlayer = $EnemyAnimationPlayer
@onready var enemy_sprite: Sprite2D = $EnemySprite2D
@onready var attack_area: Area2D = $AttackArea

# have to track when the enemy flipped rather than setting the scale everytime
var previous_velocity: Vector2 = Vector2(1,0)

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta):
	# Solution to flip the character when it changes direction on the x axis
	if velocity.x > 0 and previous_velocity.x < 0:
		scale.x = -4
	if velocity.x < 0 and previous_velocity.x > 0:
		scale.x = -4
	
	# only set previous velocity to nonzero x values
	if velocity.x != 0:
		previous_velocity = velocity
	move_and_slide()

func hit(damage: float):
	health -= damage
	if health <= 0:
		state_machine.on_outside_transition("death")
	else:
		state_machine.on_outside_transition("damage")
