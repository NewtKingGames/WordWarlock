extends EnemyClass
class_name PhantomKey

signal keyboard_letter_item_dropped(keyboard_item: KeyboardLetterPickupItem)

@onready var projectiles = $Projectiles

@export var attack_distance_to_enter: float
@export var attack_distance_to_exit: float

# Current implementation of phantom key projectiles requires it to be a child of the ghost itself, however we do NOT want it to 
# inherit transform properties of the parent. Achieving this by instantiating every projectile under the raw 'Node' object 'Projectiles'
var hand_projectile_scene: PackedScene = load("res://Scenes/projectiles/phantom_key_hand_projectile.tscn")
var keyboard_letter_pickup_item_scene: PackedScene = load("res://Scenes/items/keyboard_letter_pickup_item.tscn")

var keyboard_letter: KeyboardLetter = null


# Not responsible for playing animations, just spawns the projectile
func shoot_hands():
	var hands: PhantomKeyHandProjectile = hand_projectile_scene.instantiate()
	hands.keyboard_letter_stolen.connect(_on_hand_keyboard_letter_stolen)
	var direction: Vector2 = (player.global_position - global_position).normalized()
	hands.initial_direction = direction
	# You should implement some kind of system where they spawn a small distance away from the ghost similar to what you do with player projectiles
	hands.position = global_position
	hands.rotation = direction.angle()
	projectiles.add_child(hands)

func die():
	spawn_keyboard_letter_pickup()
	queue_free()

func spawn_keyboard_letter_pickup():
	if keyboard_letter:
		var item: KeyboardLetterPickupItem = keyboard_letter_pickup_item_scene.instantiate()
		item.keyboard_letter = keyboard_letter
		item.position = global_position
		keyboard_letter_item_dropped.emit(item)

func _on_hand_keyboard_letter_stolen(keyboard_letter_stolen: KeyboardLetter):
	keyboard_letter = keyboard_letter_stolen
	# TODO - transition to StoleKey phase
