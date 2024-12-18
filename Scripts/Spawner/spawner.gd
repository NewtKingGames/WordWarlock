class_name Spawner
extends Node2D

@export var elements_to_spawn: Array[PackedScene] = []

# TODO - consider passing in they type?
@export var is_spawning: bool:
	set(value):
		is_spawning = value
		# Start/Stop spawning
# When set to -1 there is no limit
@export var total_elements_to_spawn: int = -1
# When set to -1 there is no limit
@export var max_elements_at_once: int = -1
var current_elements: int = 0
var total_elements_spawned: int = 0
@export var spawn_interval: float = 5.0
signal spawner_finished


func _ready() -> void:
	get_tree().create_timer(spawn_interval).timeout.connect(spawn_element)

# This should probably get overridden by child classes
func spawn_element() -> Node2D:
	if check_max_elements_at_once():
		print("can't spawn right now!")
		schedule_spawner()
		return null
	if check_total_elements_spawned():
		spawner_finished.emit()
	# TODO - implement switching between different scenes by cycling through this array
	var element: Node2D = elements_to_spawn[0].instantiate()
	add_child(element)
	print("elements global position")
	print(element.global_position)
	current_elements += 1
	total_elements_spawned += 1
	connect_signals(element)
	schedule_spawner()
	return element

func _on_element_exited_scene() -> void:
	print("element exited tree")
	current_elements -= 1
	print(current_elements)

func schedule_spawner() -> void:
	# Set a timer here? You might need to use a tween callback instead in the setter method
	get_tree().create_timer(spawn_interval).timeout.connect(spawn_element)

# Enables custom spawners to add additional signals to the spawned elements
func connect_signals(element: Node2D) -> void:
	element.tree_exited.connect(_on_element_exited_scene)

func can_spawn() -> bool:
	if total_elements_to_spawn != -1 and total_elements_spawned >= total_elements_to_spawn:
		# Right here is where the spawner should be completely finished... I wonder if theres a better place for this
		return false
	if max_elements_at_once != -1 and current_elements >= max_elements_at_once:
		return false
	return true

func check_max_elements_at_once() -> bool:
	return max_elements_at_once != -1 and current_elements >= max_elements_at_once

func check_total_elements_spawned() -> bool:
	return total_elements_to_spawn != -1 and total_elements_spawned >= total_elements_to_spawn
