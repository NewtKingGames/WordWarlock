extends CharacterBody2D
class_name Player

@onready var character_animated_sprite: AnimatedSprite2D = $CharacterAnimatedSprite2D
@onready var invulnerability_timer: Timer = $Timers/InvulnerabilityTimer
@onready var stunlock_timer: Timer = $Timers/StunlockTimer
@onready var state_machine: StateMachine = $StateMachine


const walk_speed: float = 90
var can_take_damage: bool = true
# Separate timer to implement the knock back separately
var taking_damage: bool = false

var knockback_direction: Vector2 = Vector2.ZERO
@export var knockback_speed: float = 100

func _physics_process(delta):
	if not taking_damage:
		# Only flip sprite when player is intentionally moving
		if velocity.x > 0:
			character_animated_sprite.flip_h = false
		elif velocity.x < 0:
			character_animated_sprite.flip_h = true
	move_and_slide()

func hit(damage_number: float, damage_direction: Vector2):
	if can_take_damage:
		can_take_damage = false
		taking_damage = true
		invulnerability_timer.start()
		stunlock_timer.start()
		knockback_direction = damage_direction
		state_machine.on_outside_transition("damage")
		

func _on_invulnerability_timer_timeout():
	can_take_damage = true

func _on_stunlock_timer_timeout():
	taking_damage = false
