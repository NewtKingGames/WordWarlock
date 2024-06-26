extends CharacterBody2D
class_name Player

# TODO reconsile name between, spell cast and spell shot
signal spell_shot(spell_position: Vector2, spell_direction: Vector2, spell_name: String)

@onready var character_animated_sprite: AnimatedSprite2D = $CharacterAnimatedSprite2D
@onready var light_occluder_2d = $LightOccluder2D
@onready var invulnerability_timer: Timer = $Timers/InvulnerabilityTimer
@onready var stunlock_timer: Timer = $Timers/StunlockTimer
@onready var state_machine: StateMachine = $StateMachine
@onready var aiming_line = $AimingLine

const walk_speed: float = 400
var can_take_damage: bool = true
var taking_damage: bool = false
var aiming_spell: bool = true
var cast_spell_name: String = "ICE SHIELD" # TODO change this to be a Spell type itself?

var knockback_direction: Vector2 = Vector2.ZERO
@export var knockback_speed: float = 100
@export var spell_spawn_distance: float = 100 # Distance away from the player the spell will spawn

const CROSSHAIR_3 = preload("res://Sprites/v1.1 dungeon crawler 16X16 pixel pack/ui (new)/crosshair_3.png")

func _physics_process(delta):
	aiming_line.visible = aiming_spell
	# for now, handling spell aiming and casting within the main player script. If this proves to be too large of scope refactor
	if aiming_spell:
		# TODO - make cursor larger
		Input.set_custom_mouse_cursor(CROSSHAIR_3)
		if Input.is_action_just_pressed("cast_spell"):
			# TODO - change how we're passing spell information around
			# TODO SOME SPELLS DONT NEED GLOBAL POSITION THEY NEED TO SPAWN ON THE PLAYER
			# there is almost certainly going to be a better way in the future to do this, but for now these spells will never make it to the level scene
			var spell_position: Vector2
			var spell_direction: Vector2
			# TODO switch this from being hardcoded
			if cast_spell_name == "FIREBALL":
				# Put the spell from the aiming origin + some distance the player is looking
				# we have to add global_position and the relative distance aiming_line is away from the player
				spell_position = (global_position + aiming_line.position) + spell_direction*spell_spawn_distance
				# Get vector the player is looking towards
				spell_direction = (get_global_mouse_position() - global_position).normalized()
			if cast_spell_name == "ICE SHIELD":
				spell_position = Vector2.ZERO # This spell needs to spawn directly on the player
				spell_direction = Vector2.ZERO
			spell_shot.emit(spell_position, spell_direction, cast_spell_name)
			aiming_spell = false
	# Only flip sprite when player is moving from direct input
	if not taking_damage:
		if aiming_spell:
			if get_local_mouse_position().x > 0:
				character_animated_sprite.flip_h = false
				light_occluder_2d.scale.x = 1
			else:
				character_animated_sprite.flip_h = true
				light_occluder_2d.scale.x = -1
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


# TODO JUST PASS THE ACTUAL spell script or scene??? Level might not even have to care about which spell it is
func _on_spell_caster_spell_cast(spell_name):
	aiming_spell = true
	cast_spell_name = spell_name
