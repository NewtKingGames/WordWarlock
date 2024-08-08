extends ProjectileSpell
class_name Boomerang

@onready var cpu_particles_2d:CPUParticles2D = $CPUParticles2D

var ammo: int = 4
var rate_of_fire: float = 1

var max_distance: float = 400
var distance_traveled: float = 0
var retrievable_distance: float = 10
var starting_position: Vector2
var traveling_back: bool = false
var starting_speed: float
var ending_speed: float
var current_speed: float
var player: Player
const RETRO_SWOOOSH_02 = preload("res://Sounds/GameSFX/Swoosh/Retro Swooosh 02.wav")
# TODOs
# [X] Have the boomerang return to the player after hitting a wall
# [] Have the boomerang actualy collide with walls so it can't travel through them?
# [] Solve the bug that the above^ will introduce by adding a timer until the boomerang is returned
# [X] See if you can make the speed start fast and then slow down on each path <- This could still use a little bit of polish
# [] Add particle effects
# ^ you need to set the velocity of those particles to be the direction of the boomerang
# [X] Add lighting
# [X] Add sounds

func _ready():
	starting_position = global_position
	player = get_tree().get_first_node_in_group("player")
	starting_speed = spell_speed * 2
	ending_speed = spell_speed
	current_speed = starting_speed
	super._ready()

func _physics_process(delta):
	# Have the boomerang slow down towards it's destination and then speed up on the way back
	if not traveling_back:
		current_speed = lerpf(current_speed, ending_speed, delta*8)
	else:
		current_speed = lerpf(current_speed, starting_speed, delta*8)
	#print(current_speed)

# Do we need a state machine?
# I think we actually don't want this to collide with enemies
func _process(delta):
	# If the boomerang is traveling back set the direction of the spell towards the player
	if traveling_back:
		direction = (player.global_position - global_position).normalized()
	# Move the boomerang and calculate distance traveled
	position += direction*current_speed*delta
	distance_traveled = (starting_position - global_position).length()
	if distance_traveled >= max_distance:
		traveling_back = true
	cpu_particles_2d.direction = direction
	
	# Traveling back and hit the player
	if traveling_back and (player.global_position - global_position).length() < retrievable_distance:
		#print("the speed was")
		#print(current_speed)
		queue_free()

# OVERRIDE
static func get_spell_color():
	return Color.WEB_PURPLE

func boomerang_hit_body(body):
	spell_hit_body(body)
	# Flash a light or other animations?
	$PointLight2D.energy = 1.5
	await get_tree().create_timer(.1).timeout
	$PointLight2D.energy = 0
	
func _on_body_entered(body):
	boomerang_hit_body(body)
	 #If we hit a wall we return the boomerang back to the player
	if is_instance_of(body, TileMap):
		traveling_back = true
