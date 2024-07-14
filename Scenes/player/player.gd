extends CharacterBody2D
class_name Player

signal casting_state_entered
signal casting_state_exited
signal casting_key_pressed(letter_string: String)
signal spell_shot(spell: Spell)

@onready var character_animated_sprite: AnimatedSprite2D = $CharacterAnimatedSprite2D
@onready var light_occluder_2d = $LightOccluder2D
@onready var invulnerability_timer: Timer = $Timers/InvulnerabilityTimer
@onready var stunlock_timer: Timer = $Timers/StunlockTimer
@onready var state_machine: StateMachine = $StateMachine
@onready var aiming_line = $AimingLine

const walk_speed: float = 400
var can_take_damage: bool = true
var taking_damage: bool = false
var aiming_spell: bool = false
var queued_spell: Spell
var is_spell_book_open: bool = false

var knockback_direction: Vector2 = Vector2.ZERO
@export var knockback_speed: float = 100 # TODO DELETE
@export var spell_spawn_distance: float = 100 # Distance away from the player the spell will spawn

const CROSSHAIR_3 = preload("res://Sprites/v1.1 dungeon crawler 16X16 pixel pack/ui (new)/crosshair_3.png")


func _process(delta):
	if not can_take_damage:
		$DamageAnimationPlayer.play("damage_flash")
	if can_take_damage:
		$DamageAnimationPlayer.stop()
	# TODO - it's probably worth creating an entire new state for the spell book logic
	if state_machine.current_state != $StateMachine/Cast:
		if Input.is_action_just_pressed("spell_book"):
			is_spell_book_open = (bool)(!is_spell_book_open)
		if is_spell_book_open:
			Engine.time_scale = 0
		else:
			Engine.time_scale = 1

func _physics_process(delta):
	aiming_line.visible = aiming_spell
	# for now, handling spell aiming and casting within the main player script. Consider refactoring to it's own nod
	if aiming_spell:
		# TODO - make cursor larger
		Input.set_custom_mouse_cursor(CROSSHAIR_3)
		if Input.is_action_just_pressed("cast_spell"):
			# TODO this might not be necessary? Defaults are set on class?
			queued_spell.position = Vector2.ZERO
			if is_instance_of(queued_spell, Fireball): # Todo could make this check for projectile spell? Shouldn't be specific to fireball
				# Get vector the player is looking towards
				queued_spell.direction = (get_global_mouse_position() - global_position).normalized()
				# Put the spell from the aiming origin + some distance the player is looking
				# we have to add global_position and the relative distance aiming_line is away from the player
				queued_spell.position = (global_position + aiming_line.position) + queued_spell.direction*spell_spawn_distance
				queued_spell.rotation = queued_spell.direction.angle()
			if is_instance_of(queued_spell, Thunderstorm):
				queued_spell.position = global_position
			spell_shot.emit(queued_spell)
			aiming_spell = false # consider just relying on setting the queued spell to null?
			
	# Only flip sprite when player is moving from direct input or aiming a spell
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
		if Globals.player_health > 0:
			state_machine.on_outside_transition("damage")
		else:
			state_machine.on_outside_transition("death")

func _on_invulnerability_timer_timeout():
	can_take_damage = true

func _on_stunlock_timer_timeout():
	taking_damage = false

func _on_spell_caster_spell_cast(spell_node: Spell):
	aiming_spell = true
	queued_spell = spell_node
