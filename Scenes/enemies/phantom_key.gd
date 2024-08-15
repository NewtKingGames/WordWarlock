extends EnemyClass
class_name PhantomKey

signal keyboard_letter_item_dropped(keyboard_item: KeyboardLetterPickupItem)
@onready var collision_shape_2d = $CollisionShape2D

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
	hands.max_distance_traveled.connect(_on_projectile_miss)
	var direction: Vector2 = (player.global_position - global_position).normalized()
	hands.initial_direction = direction
	# You should implement some kind of system where they spawn a small distance away from the ghost similar to what you do with player projectiles
	hands.position = global_position
	hands.rotation = direction.angle()
	projectiles.add_child(hands)
	
	# Make the ghost invisible and untouchable i.e. no collisions, no damage, no visibility
	toggle_ghost_visible(false)
	# Maybe set speed to zero as well?

func die():
	spawn_keyboard_letter_pickup()
	queue_free()

func spawn_keyboard_letter_pickup():
	if keyboard_letter:
		var item: KeyboardLetterPickupItem = keyboard_letter_pickup_item_scene.instantiate()
		item.keyboard_letter = keyboard_letter
		item.position = global_position
		keyboard_letter_item_dropped.emit(item)

func has_key():
	return keyboard_letter != null


func ghost_reappear():
	toggle_ghost_visible(true)
	collision_shape_2d.set_deferred("disabled", false)
	if keyboard_letter:
		$LetterSprite.set_letter_string(keyboard_letter.letter_string)
		$StateMachine.on_outside_transition("StoleKey")
	else:
		$StateMachine.on_outside_transition("MissKey")

func toggle_ghost_visible(is_visible: bool):
	visible = is_visible
	collision_shape_2d.set_deferred("disabled", !is_visible)# Docs say this property should be modified with set_deffered
	
func _on_hand_keyboard_letter_stolen(keyboard_letter_stolen: KeyboardLetter):
	# Consider where the ghost should reappear in this state
	keyboard_letter = keyboard_letter_stolen
	ghost_reappear()
	# TODO - transition to StoleKey phase

func _on_projectile_miss(final_position: Vector2):
	position = final_position
	ghost_reappear()
