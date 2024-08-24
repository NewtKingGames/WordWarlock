extends CharacterBody2D
class_name Player

signal slowdown_effect_entered
signal slowdown_effect_exited
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
@onready var keyboard: Keyboard = $Keyboard
@onready var auto_aim_attack_area = $AutoAimAttackArea
@onready var aim_lock_on_reticle: Reticle = $AimLockOnReticle



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

const CROSSHAIR_3 = preload("res://Sprites/v1.1 dungeon crawler 16X16 pixel pack/ui (new)/crosshair_3.png")

# Variables related to music slowdown and speed up effects
var level_music: AudioStreamPlayer2D
const pitch_scale_slow: float = .5
const pitch_scale_max: float = 1
const pitch_scale_rate_up: float = 8
var pitch_scale_rate_down: float = pitch_scale_rate_up * (1.0/Globals.engine_slowdown_magnitude)
var target_pitch: float = pitch_scale_max

# Variables related to visual status effects
var is_haste_active: bool = false

# Variable used to control if player can shoot a projectile spell again
var can_cast_again = true

var locked_on_enemy: EnemyClass
var closest_enemies_in_range: Array[EnemyClass] = []
# This will control how we lock on to enemies this needs to be set in two ways:
# 1. if the player hits tab we increment this by 1
# 2. if the total amount of closest enemies goes to zero we set this to zero
# 3. if the index is >= size of closest enemies we set this to 0
var lock_on_index: int = 0
##
## TODO!!! The player can eject themself out of the cast state when the next queued spell shoots, it would be nice to prevent this from happening! 
##
func _ready():
	level_music = get_tree().get_first_node_in_group("music")

func _process(delta):
	# Reconsider choice to rely on global variables
	if Globals.player_walk_speed > Globals.player_base_walk_speed:
		character_animated_sprite.material.set_shader_parameter("color", Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1)))
	else:
		character_animated_sprite.material.set_shader_parameter("color", Color(0, 0, 0, 0))
	# Alter the pitch scale of the music on slowdown/speed up
	if level_music.pitch_scale < target_pitch:
		level_music.pitch_scale = lerpf(level_music.pitch_scale, target_pitch, pitch_scale_rate_up*delta)
	elif level_music.pitch_scale > target_pitch:
		level_music.pitch_scale = lerpf(level_music.pitch_scale, target_pitch, pitch_scale_rate_down*delta)
	# Effects while player is in invulnerable cooldown
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
		if Globals.player_slowdown_pool > 0:
			slowdown_effect_start()
		else:
			slowdown_effect_stop()
		slowdown_pool_consumed += spell_slowdown_decrease_rate * delta
		Globals.player_slowdown_pool = Globals.player_slowdown_pool - spell_slowdown_decrease_rate * delta
	else:
		slowdown_pool_consumed = 0
		Globals.player_slowdown_pool = Globals.player_slowdown_pool + spell_slowdown_increase_rate * delta

func _physics_process(delta):
	
	if Input.is_action_just_pressed("switch_target"):
		lock_on_index += 1
	# Calculate the nearest enemy - TODO could only run this every X frames to cut back?
	# TODO - how to respect the players current lock on target? this might become an issue where you need to save a reference to the currently locked on enemy and then check track where in the array it is when a new enemy comes in
	closest_enemies_in_range = get_nearest_enemies_in_range_in_order()
	if lock_on_index != 0 and lock_on_index >= closest_enemies_in_range.size():
		lock_on_index = 0
	# Grab the closest locked on enemy
	var closest_enemy: EnemyClass = null
	if closest_enemies_in_range.size() > 0:
		closest_enemy = closest_enemies_in_range[lock_on_index]
	if closest_enemy:
		locked_on_enemy = closest_enemy
		aim_lock_on_reticle.set_target_node(closest_enemy)
	else:
		locked_on_enemy = null
		aim_lock_on_reticle.set_target_node(null)
	
	if Globals.cast_spells_with_mouse:
		aiming_line.visible = queued_spell != null
	# for now, handling spell aiming and casting within the main player script. Consider refactoring to it's own node
	if queued_spell != null:
		if not Globals.cast_spells_with_mouse:
			autocast_spell()
		Input.set_custom_mouse_cursor(CROSSHAIR_3)
		if Input.is_action_just_pressed("cast_spell") and Globals.cast_spells_with_mouse:
			if is_instance_of(queued_spell, ProjectileSpell):
				# Get vector the player is looking towards
				queued_spell.direction = (get_global_mouse_position() - global_position).normalized()
				# Put the spell from the aiming origin + some distance the player is looking
				# we have to add global_position and the relative distance aiming_line is away from the player
				queued_spell.position = (global_position + aiming_line.position) + queued_spell.direction*spell_spawn_distance
				queued_spell.rotation = queued_spell.direction.angle()
			if is_instance_of(queued_spell, Thunderstorm):
				queued_spell.position = global_position
			shoot_queued_spell()
			
	# Only flip sprite when player is moving from direct input or aiming a spell
	# how to flip the sprite briefly while shooting?
	if not taking_damage:
		if queued_spell != null and Globals.cast_spells_with_mouse:
			if get_local_mouse_position().x > 0:
				character_animated_sprite.flip_h = false
				light_occluder_2d.scale.x = 1
			else:
				character_animated_sprite.flip_h = true
				light_occluder_2d.scale.x = -1
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

func shoot_queued_spell():
	spell_shot.emit(queued_spell)
	state_machine.on_outside_transition("shotspell")
	queued_spell_ammo -= 1
	if queued_spell_ammo <= 0:
		queued_spell = null
	else:
		queued_spell = queued_spell_scene.instantiate()

func _on_invulnerability_timer_timeout():
	can_take_damage = true

func _on_stunlock_timer_timeout():
	taking_damage = false

# This signal is NOT the signal containing the actual spell. This is just a signal indicating the player hit enter on text they typed
func _on_cast_cast_spell(string: String):
	spell_string_cast.emit(string)


# Bit of a bummer, I can't type hint typed_string and spell_scene because nulling them out doesn't work. Is it an issue with typed Scene?
# TODO - the solution here is to create a custom "Object" which is simply a payload for all of these values which does support nulling these out akin to an API contract
func _on_cast_spell_state_changed(is_casting: bool, typed_string, spell_scene):
	is_player_casting = is_casting
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
			# Effect spells are immediately cast after typing
			if is_instance_of(queued_spell, EffectSpell):
				spell_shot.emit(queued_spell)
				queued_spell = null
				return 
			# Some spells have 'ammo' allowing the spell to be cast multiple times in a row
			if "ammo" in queued_spell:
				queued_spell_ammo = queued_spell.ammo
			else:
				queued_spell_ammo = 1

func disable_random_key() -> KeyboardLetter:
	return keyboard.disable_random_key()

func autocast_spell():
	if is_instance_of(queued_spell, ProjectileSpell):
		if not can_cast_again:
			return
		can_cast_again = false
		var timer: SceneTreeTimer = get_tree().create_timer(queued_spell.rate_of_fire)
		timer.connect("timeout", on_fire_rate_timeout)
		#var closest_enemy: EnemyClass = get_nearest_enemy_in_range()
		var closest_enemy = locked_on_enemy
		print(locked_on_enemy)
		# TODO - handle null scenario
		var spell_target: Vector2
		if closest_enemy:
			spell_target = closest_enemy.global_position
		else:
			# TODO maybe shoot the spell in a random direction? Right now just shooting it right
			spell_target = global_position + Vector2(75, 0)
			print("Found no enemies close enough!!")
		# Get vector betwen player and closest enemy
		queued_spell.direction = (spell_target - global_position).normalized()
		# Put the spell from the aiming origin + some distance the player is looking
		# we have to add global_position and the relative distance aiming_line is away from the player
		# TODO make sure this aiming line still works properly in new flow
		queued_spell.position = (global_position + aiming_line.position) + queued_spell.direction*spell_spawn_distance
		queued_spell.rotation = queued_spell.direction.angle()
	if is_instance_of(queued_spell, Thunderstorm):
		queued_spell.position = global_position
	shoot_queued_spell()

func on_fire_rate_timeout():
	can_cast_again = true

# according to the docs this might not be the most accurate way to do this, consider using signals
func get_nearest_enemy_in_range() -> EnemyClass:
	var overlapping_bodies: Array[Node2D] = auto_aim_attack_area.get_overlapping_bodies()
	var closest_enemy: EnemyClass = null
	for over_lapping_body: Node2D in overlapping_bodies:
		if over_lapping_body is EnemyClass:
			# Check if the enemy is within a line of sight of the player
			if not is_in_line_of_sight(over_lapping_body):
				continue
			if closest_enemy:
				if position.distance_to(closest_enemy.global_position) > position.distance_to(over_lapping_body.global_position):
					closest_enemy = over_lapping_body
			else:
				closest_enemy = over_lapping_body
	return closest_enemy

func get_nearest_enemies_in_range_in_order() -> Array[EnemyClass]:
	var overlapping_bodies: Array[Node2D] = auto_aim_attack_area.get_overlapping_bodies()
	var enemies_in_range: Array[EnemyClass] = []
	var enemy_count_in_range: int = 0
	for over_lapping_body: Node2D in overlapping_bodies:
		if over_lapping_body is EnemyClass:
			# Check if the enemy is within a line of sight of the player
			if not is_in_line_of_sight(over_lapping_body):
				continue
			enemies_in_range.append(over_lapping_body)
			enemy_count_in_range += 1
	# We need to resize the array to only contain non-null values?
	enemies_in_range.resize(enemy_count_in_range)
	enemies_in_range.sort_custom(sort_asc_distance)
	return enemies_in_range

func sort_asc_distance(a: Node2D, b: Node2D):
	if a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position):
		return true
	return false

# TODO - This isn't working correctly all the time... You're still hitting collisions? 
# I think it has to do with your start and end of the raycast, see if you can print it?
func is_in_line_of_sight(object: Node2D):
	var space_state = get_world_2d().direct_space_state
	var line_of_sight_query = PhysicsRayQueryParameters2D.create(global_position, object.global_position)
	#line_of_sight_query.set_collide_with_areas(true)
	var result: Dictionary = space_state.intersect_ray(line_of_sight_query)
	if result:
		if result.has("collider"):
			if is_instance_of(result["collider"], TileMap):
				#print("hit a collider?")
				#print(result)
				return false
	return true

# Slow down control code - probably should be moved to it's own scene
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
