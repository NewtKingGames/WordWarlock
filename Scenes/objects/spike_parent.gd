# @tool allows this code to be ran in the editor
@tool
class_name SpikeParent
extends Node2D
const SPIKES_SCENE: PackedScene = preload("res://Scenes/objects/spikes.tscn")
@onready var activate_spike_noise: AudioStreamPlayer2D = $ActivateSpikeNoise
@onready var deactivate_spike_noise: AudioStreamPlayer2D = $DeactivateSpikeNoise
@export var num_spikes_x: int = 0:
	set(num):
		num_spikes_x = num
		_delete_all_spikes()
		create_spikes()
@export var num_spikes_y: int = 0:
	set(num):
		num_spikes_y = num
		_delete_all_spikes()
		create_spikes()

#@export var auto_start_spikes: bool = true
@export var is_spikes_on_timer: bool = true
# Timer values used if the above boolean is true
@export var activate_spike_delay: float = 3
@export var deactivate_spike_delay: float = 1.5

func _ready() -> void:
	# Only run this ready function when scene is loaded outside of the editor
	if not Engine.is_editor_hint():
		create_spikes()
		get_tree().create_timer(activate_spike_delay).timeout.connect(activate_spikes)

func create_spikes() -> void:
	# Create the spikes:
	var spike_position: Vector2 = position
	for x in range(num_spikes_x):
		for y in range(num_spikes_y):
			var spikes: Spikes = SPIKES_SCENE.instantiate()
			spikes.position = Vector2(63*x, 63*y)
			add_child(spikes)
			if Engine.is_editor_hint():
				spikes.owner = self

func activate_spikes() -> void:
	activate_spike_noise.play()
	for spike_child in get_children():
		if spike_child is Spikes:
			spike_child.activate_spikes()
	get_tree().create_timer(deactivate_spike_delay).timeout.connect(deactivate_spikes)

func deactivate_spikes() -> void:
	deactivate_spike_noise.play()
	for spike_child in get_children():
		if spike_child is Spikes:
			spike_child.deactivate_spikes()
	get_tree().create_timer(deactivate_spike_delay).timeout.connect(activate_spikes)


func _delete_all_spikes() -> void:
	for child in get_children():
		if child is Spikes:
			child.queue_free()
