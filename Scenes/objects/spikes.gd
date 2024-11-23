class_name Spikes
extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func activate_spikes() -> void:
	animated_sprite_2d.play("activate_spikes")

func deactivate_spikes() -> void:
	animated_sprite_2d.play("deactivate_spikes")
