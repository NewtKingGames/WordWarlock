class_name TypingNoises
extends Node2D
@onready var local_typing_sounds: Node2D = $LocalTypingSounds
@onready var global_typing_sounds: Node = $GlobalTypingSounds

# TODO - you could control the volume of all of these effects here!

func play_typing_noise() -> void:
	var typing_noise_index: int = randi_range(0, local_typing_sounds.get_child_count()-1)
	local_typing_sounds.get_child(typing_noise_index).pitch_scale = randf_range(.9, 1.05)
	local_typing_sounds.get_child(typing_noise_index).play()

# Plays the typing noise from AudiostreamObjects which don't have position
func play_typing_noise_global() -> void:
	var typing_noise_index: int = randi_range(0, global_typing_sounds.get_child_count()-1)
	global_typing_sounds.get_child(typing_noise_index).pitch_scale = randf_range(.9, 1.05)
	global_typing_sounds.get_child(typing_noise_index).play()