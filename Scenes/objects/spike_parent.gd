class_name SpikeParent
extends Node2D
@onready var spike_nodes: Node2D = $SpikeNodes
@onready var activate_spike_noise: AudioStreamPlayer2D = $ActivateSpikeNoise
@onready var deactivate_spike_noise: AudioStreamPlayer2D = $DeactivateSpikeNoise


#@export var auto_start_spikes: bool = true
@export var is_spikes_on_timer: bool = true
# Timer values used if the above boolean is true
@export var activate_spike_delay: float = 5
@export var deactivate_spike_delay: float = 5

func _ready() -> void:
	get_tree().create_timer(activate_spike_delay).timeout.connect(activate_spikes)

func activate_spikes() -> void:
	activate_spike_noise.play()
	for spike_child in spike_nodes.get_children():
		if spike_child is Spikes:
			spike_child.activate_spikes()
	get_tree().create_timer(deactivate_spike_delay).timeout.connect(deactivate_spikes)

func deactivate_spikes() -> void:
	deactivate_spike_noise.play()
	get_tree().create_timer(deactivate_spike_delay).timeout.connect(activate_spikes)
