extends CharacterBody2D
class_name Player

# TODO reconsile name between, spell cast and spell shot
signal spell_shot(spell_name: String)

@onready var character_animated_sprite: AnimatedSprite2D = $CharacterAnimatedSprite2D
@onready var invulnerability_timer: Timer = $Timers/InvulnerabilityTimer
@onready var stunlock_timer: Timer = $Timers/StunlockTimer
@onready var state_machine: StateMachine = $StateMachine
@onready var aiming_line = $AimingLine

const walk_speed: float = 400
var can_take_damage: bool = true
var taking_damage: bool = false
var aiming_spell: bool = true

var knockback_direction: Vector2 = Vector2.ZERO
@export var knockback_speed: float = 100

const CROSSHAIR_3 = preload("res://Sprites/v1.1 dungeon crawler 16X16 pixel pack/ui (new)/crosshair_3.png")

func _physics_process(delta):
	aiming_line.visible = aiming_spell
	# for now, handling spell aiming and casting within the main player script. If this proves to be too large of scope refactor
	if aiming_spell:
		# TODO - make cursor larger
		Input.set_custom_mouse_cursor(CROSSHAIR_3)
		if Input.is_action_just_pressed("cast_spell"):
			# TODO - change how we're passing spell information around
			spell_shot.emit("FIREBALL")
			aiming_spell = false
	# Only flip sprite when player is moving from direct input
	if not taking_damage:
		if aiming_spell:
			if get_local_mouse_position().x > 0:
				character_animated_sprite.flip_h = false
			else:
				character_animated_sprite.flip_h = true
		else:
			if velocity.x > 0:
				character_animated_sprite.flip_h = false
			elif velocity.x < 0:
				character_animated_sprite.flip_h = true
	move_and_slide()

func hit(damage_number: float, damage_direction: Vector2):
	if can_take_damage:
		Globals.player_health -= damage_number
		can_take_damage = false
		taking_damage = true
		invulnerability_timer.start()
		stunlock_timer.start()
		knockback_direction = damage_direction
		# TODO - check if performing the globals player health check here is problematic with signals, wondering if the signal needs to be sent from globals
		if Globals.player_health > 0:
			state_machine.on_outside_transition("damage")
		else:
			state_machine.on_outside_transition("death")
		

func _on_invulnerability_timer_timeout():
	can_take_damage = true

func _on_stunlock_timer_timeout():
	taking_damage = false


# TODO whole lot more to do here with regards to creating the spell in game
func _on_spell_caster_spell_cast(spell_name):
	aiming_spell = true
