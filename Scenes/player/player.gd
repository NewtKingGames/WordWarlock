extends CharacterBody2D
class_name Player

signal slowdown_effect_entered
signal slowdown_effect_exited
signal casting_state_changed(is_casting: bool)
signal casting_key_pressed(letter_string: String)
# This signal is used to pass the actual spell object to the object responsible for adding them to the scene
signal spell_shot(spell: Spell)
# This signal is used to simply tell the game that the player hit enter on some string, spell or not
signal spell_string_cast(string: String)

@onready var character_animated_sprite: AnimatedSprite2D = $CharacterAnimatedSprite2D
@onready var light_occluder_2d = $LightOccluder2D
@onready var invulnerability_timer: Timer = $Timers/InvulnerabilityTimer
@onready var stunlock_timer: Timer = $Timers/StunlockTimer
@onready var state_machine: StateMachine = $StateMachine
@onready var aiming_line = $AimingLine
@onready var slow_mo_sound_enter = $Sounds/SlowMoSoundEnter
@onready var slow_mo_sound_exit = $Sounds/SlowMoSoundExit


const walk_speed: float = 400
var can_take_damage: bool = true
var taking_damage: bool = false

var queued_spell: Spell
var queued_spell_scene: PackedScene
var queued_spell_ammo: int = 0

var is_spell_book_open: bool = false
var is_player_casting: bool = false

var knockback_direction: Vector2 = Vector2.ZERO
@export var spell_spawn_distance: float = 100 # Distance away from the player the spell will spawn

var spell_slowdown_decrease_rate: float = 80.0
var spell_slowdown_increase_rate: float = 22.0
# TODO - track the total current amount of spell slowdown lost in a single charge as a variable
var slowdown_pool_consumed: float = 0
var player_has_combo: bool = false 
var spells_in_combo: int = 0
# Idea for the combo system:
# You could reduce your signals from 'cast' down to a single signal which includes:
# (is_casting: true/false, spell_string null or the string, spell_scene null or the scene cast)
# If we do that then we can tell: 1. Did we leave the state due to a casting of the spell or because we tried to cast a spell and if we did was it succesful?

const CROSSHAIR_3 = preload("res://Sprites/v1.1 dungeon crawler 16X16 pixel pack/ui (new)/crosshair_3.png")

var level_music: AudioStreamPlayer2D

const pitch_scale_slow: float = .5
const pitch_scale_max: float = 1
const pitch_scale_rate_up: float = 8
var pitch_scale_rate_down: float = pitch_scale_rate_up * (1.0/Globals.engine_slowdown_magnitude)
var target_pitch: float = pitch_scale_max

func _ready():
	level_music = get_tree().get_first_node_in_group("music")

func _process(delta):
	if level_music.pitch_scale < target_pitch:
		level_music.pitch_scale = lerpf(level_music.pitch_scale, target_pitch, pitch_scale_rate_up*delta)
	elif level_music.pitch_scale > target_pitch:
		level_music.pitch_scale = lerpf(level_music.pitch_scale, target_pitch, pitch_scale_rate_down*delta)
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
			
	# Handling player slowdown bar
	if is_player_casting:
		# The order of changing the value vs these if statements might really matter, not sure if this is correct
		if Globals.player_slowdown_pool > 0:
			slowdown_effect_start()
		else:
			slowdown_effect_stop()
		slowdown_pool_consumed += spell_slowdown_decrease_rate * delta
		print("slowdown pool consumed")
		print(slowdown_pool_consumed)
		Globals.player_slowdown_pool = Globals.player_slowdown_pool - spell_slowdown_decrease_rate * delta
	else:
		slowdown_pool_consumed = 0
		Globals.player_slowdown_pool = Globals.player_slowdown_pool + spell_slowdown_increase_rate * delta

func _physics_process(delta):
	aiming_line.visible = queued_spell != null
	# for now, handling spell aiming and casting within the main player script. Consider refactoring to it's own node
	if queued_spell != null:
		# TODO - make cursor larger
		Input.set_custom_mouse_cursor(CROSSHAIR_3)
		if Input.is_action_just_pressed("cast_spell"):
			if is_instance_of(queued_spell, ProjectileSpell):
				# Get vector the player is looking towards
				queued_spell.direction = (get_global_mouse_position() - global_position).normalized()
				# Put the spell from the aiming origin + some distance the player is looking
				# we have to add global_position and the relative distance aiming_line is away from the player
				queued_spell.position = (global_position + aiming_line.position) + queued_spell.direction*spell_spawn_distance
				queued_spell.rotation = queued_spell.direction.angle()
			if is_instance_of(queued_spell, Thunderstorm):
				queued_spell.position = global_position
			spell_shot.emit(queued_spell)
			queued_spell_ammo -= 1
			if queued_spell_ammo <= 0:
				queued_spell = null
			else:
				queued_spell = queued_spell_scene.instantiate()
			
	# Only flip sprite when player is moving from direct input or aiming a spell
	if not taking_damage:
		if queued_spell != null:
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

func _on_spell_caster_spell_cast(spell_scene: PackedScene):
	return
	queued_spell_scene = spell_scene
	queued_spell = spell_scene.instantiate()
	# Some spells have 'ammo' allowing the spell to be cast multiple times in a row
	if "ammo" in queued_spell:
		queued_spell_ammo = queued_spell.ammo
	else:
		queued_spell_ammo = 1

# This signal is NOT the signal containing the actual spell. This is just a signal indicating the player hit enter on text they typed
func _on_cast_cast_spell(string: String):
	spell_string_cast.emit(string)

func _on_spell_caster_state_changed(is_casting: bool):
	return
	if is_casting:
		slowdown_effect_start()
	else:
		slowdown_effect_stop()
		if player_has_combo:
			Globals.player_slowdown_pool += (slowdown_pool_consumed * .66)
	is_player_casting = is_casting
	casting_state_changed.emit(is_casting)


# Bit of a bummer, I can't type hint typed_string and spell_scene because nulling them out doesn't work. Is it an issue with typed Scene?
# TODO - the solution here is to create a custom "Object" which is simply a payload for all of these values which does support nulling these out akin to an API contract
func _on_cast_spell_state_changed(is_casting: bool, typed_string, spell_scene):
	# Handling state entered
	if is_casting:
		slowdown_effect_start()
		return
	else:
		# Handling state exit
		slowdown_effect_stop()
		# TODO handle the different combinations of the player leaving the state
		if spell_scene:
			queued_spell_scene = spell_scene
			queued_spell = spell_scene.instantiate()
			# Some spells have 'ammo' allowing the spell to be cast multiple times in a row
			if "ammo" in queued_spell:
				queued_spell_ammo = queued_spell.ammo
			else:
				queued_spell_ammo = 1
	is_player_casting = is_casting
	casting_state_changed.emit(is_casting)
	

func slowdown_effect_start():
	# Prevent duplicate effects from playing
	if Engine.time_scale == Globals.engine_slowdown_magnitude:
		return
	slow_mo_sound_enter.play()
	slow_mo_sound_exit.stop()
	Engine.time_scale = Globals.engine_slowdown_magnitude
	target_pitch = pitch_scale_slow
	slowdown_effect_entered.emit()

func slowdown_effect_stop():
	# Prevent duplicate effects from playing
	if Engine.time_scale == 1.0:
		return
	slow_mo_sound_enter.stop()
	slow_mo_sound_exit.play()
	Engine.time_scale = 1
	target_pitch = pitch_scale_max
	slowdown_effect_exited.emit()
