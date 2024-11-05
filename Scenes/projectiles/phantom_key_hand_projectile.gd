extends Area2D
class_name PhantomKeyHandProjectile

@onready var fist_projectile = $FistProjectile
@onready var hit_effect = $HitEffect
@onready var collision_shape_2d = $CollisionShape2D


signal keyboard_letter_stolen(keyboard_letter: KeyboardLetter)
signal max_distance_traveled(final_position: Vector2)

# TODO - should this projectile have any kind of auto aim??

@export var max_distance_to_travel: float = 400

var initial_position: Vector2
var player: Player
var projectile_speed: float = 400
var initial_direction: Vector2
var destination_rotation: float

func _ready():
	# TODO figure out how to get the fist to rotate smoothly towards the player
	player = get_tree().get_first_node_in_group("player")
	initial_position = position
	destination_rotation = rotation
	destination_rotation
	# This idea doesn't quite work because you need to specify the direction to tween in
	#var rotate_tween: Tween = create_tween()
	#rotate_tween.tween_property(self, "rotation", destination_rotation, 1).as_relative()

func _process(delta: float):
	position = position + (initial_direction * projectile_speed * delta)
	if initial_position.distance_to(position) >= max_distance_to_travel:
		projectile_speed = 0
		max_distance_traveled.emit(global_position)
		destroy_projectile()

func _on_body_entered(body):
	if is_instance_of(body, Player):
		var keyboard_letter: KeyboardLetter = body.disable_random_key()
		print(keyboard_letter)
		keyboard_letter_stolen.emit(keyboard_letter)
		# Add knockback for no damage to ghost
		body.hit(0, initial_direction*100)
	destroy_projectile()

# Object gets queued free in sprite animated 2d signal for 
func destroy_projectile():
	# TODO Play some animations and effects
	projectile_speed = 0
	fist_projectile.visible = false
	hit_effect.visible = true
	collision_shape_2d.set_deferred("disabled", !is_visible)
	hit_effect.play("hit")

func _on_hit_effect_animation_finished():
	queue_free()
