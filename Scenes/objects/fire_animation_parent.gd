@tool
class_name FireAnimationParent
extends Node2D
const FIRE_ANIMATION: PackedScene = preload("res://Scenes/areas/fire_animation.tscn")

@export var num_fire_x: int = 0:
	set(num):
		num_fire_x = num
		_delete_all_fire()
		create_fire_children()
@export var num_fire_y: int = 0:
	set(num):
		num_fire_y = num
		_delete_all_fire()
		create_fire_children()

func _ready() -> void:
	# Only run this ready function when scene is loaded outside of the editor
	if not Engine.is_editor_hint():
		create_fire_children()

func start_fires() -> void:
	for fire_child in get_children():
		if fire_child is FireAnimation:
			fire_child.start_fire()

func stop_fires() -> void:
	for fire_child in get_children():
		if fire_child is FireAnimation:
			fire_child.stop_fire()

func create_fire_children() -> void:
	# Create the spikes:
	var fire_position: Vector2 = position
	for x in range(num_fire_x):
		for y in range(num_fire_y):
			var fire: FireAnimation = FIRE_ANIMATION.instantiate()
			fire.position = Vector2(63*x, 63*y)
			add_child(fire)
			if Engine.is_editor_hint():
				fire.owner = self

func _delete_all_fire() -> void:
	for child in get_children():
		if child is FireAnimation:
			child.queue_free()
