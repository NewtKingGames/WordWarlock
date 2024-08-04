extends ProjectileSpell
class_name Boomerang

var max_distance: float = 200
var distance_traveled: float = 0
var retrievable_distance: float = 10
var starting_position: Vector2
var traveling_back: bool = false
var player: Player

# TODOs
# [] Have the boomerang collide with walls
# [] Solve the bug that the above^ will introduce by adding a timer until the boomerang is returned
# [] See if you can make the speed start fast and then slow down on each path
# [] Add particle effects
# [] Add lighting

func _ready():
	starting_position = global_position
	player = get_tree().get_first_node_in_group("player")

# Do we need a state machine?
# I think we actually don't want this to collide with enemies
func _process(delta):
	# If the boomerang is traveling back set the direction of the spell towards the player
	if traveling_back:
		direction = (player.global_position - global_position).normalized()
	# Move the boomerang and calculate distance traveled
	position += direction*spell_speed*delta
	distance_traveled = (starting_position - global_position).length()
	if distance_traveled >= max_distance:
		print("boomerang hit max distance!")
		traveling_back = true
	# Traveling back and hit the player
	if traveling_back and (player.global_position - global_position).length() < retrievable_distance:
		queue_free()

# OVERRIDE
static func get_spell_color():
	return Color.WEB_PURPLE
