extends Area2D
class_name PhantomKeyHandProjectile


signal keyboard_letter_stolen(keyboard_letter: KeyboardLetter)
signal max_distance_traveled

# TODO - should this projectile have any kind of auto aim??

var player: Player
var projectile_speed: float = 180
var initial_direction: Vector2

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float):
	position = position + (initial_direction * projectile_speed * delta)

func _on_body_entered(body):
	if is_instance_of(body, Player):
		var keyboard_letter: KeyboardLetter = body.disable_random_key()
		print(keyboard_letter)
		keyboard_letter_stolen.emit(keyboard_letter)
	destroy_projectile()

func destroy_projectile():
	# TODO Play some animations and effects
	queue_free()
	
