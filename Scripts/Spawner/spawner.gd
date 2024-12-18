class_name Spawner
extends Node2D

signal spawner_finished_spawning
signal all_spawner_elements_destroyed

enum SpawnMode {RANDOM, ITERATE}


@export var elements_to_spawn: Array[PackedScene] = []

# TODO - consider passing in the enemy type?
@export var is_spawning: bool:
	set(value):
		is_spawning = value
		# Start/Stop spawning
# When set to -1 there is no limit
@export var total_elements_to_spawn: int = -1
# When set to -1 there is no limit
@export var max_elements_at_once: int = -1
@export var spawn_interval_max: float = 3.0
@export var spawn_interval_min: float = 1.0
@export var spawn_mode: SpawnMode = SpawnMode.RANDOM

var current_elements: int = 0
var total_elements_spawned: int = 0
var total_elements_destroyed: int = 0: 
	set(value):
		total_elements_destroyed = value
		if total_elements_destroyed == total_elements_to_spawn:
			all_spawner_elements_destroyed.emit()
var current_spawn_scene_index: int = 0



func _ready() -> void:
	if is_spawning:
		schedule_spawner()

# This should probably get overridden by child classes
func spawn_element() -> Node2D:
	if check_max_elements_at_once():
		schedule_spawner()
		return null
	if check_total_elements_spawned():
		spawner_finished_spawning.emit()
		return null
	var element: Node2D = elements_to_spawn[current_spawn_scene_index].instantiate()
	current_spawn_scene_index = get_next_index(current_spawn_scene_index)
	add_child(element)
	current_elements += 1
	total_elements_spawned += 1
	connect_signals(element)
	schedule_spawner()
	return element

func _on_element_exited_scene() -> void:
	current_elements -= 1
	total_elements_destroyed += 1

func schedule_spawner() -> void:
	get_tree().create_timer(randf_range(spawn_interval_min, spawn_interval_max), true, false, true).timeout.connect(spawn_element)

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

func get_next_index(current_index: int) -> int:
	if spawn_mode == SpawnMode.RANDOM:
		return randi_range(0, elements_to_spawn.size()-1)
	else:
		return (current_index + 1) % elements_to_spawn.size()
