class_name KeyboardLetterFrozen
extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var key_pressed_sound: AudioStreamPlayer2D = $KeyPressedSound
@onready var key_broken_sound: AudioStreamPlayer2D = $KeyBrokenSound

signal ice_broken

var current_hits = 0 : 
	set(value):
		current_hits = value
		if value == hits_to_break:
			break_ice()
		else: 
			ice_pressed_effects()
@export var hits_to_break: int = 4

func key_pressed() -> void:
	if current_hits < hits_to_break:
		current_hits += 1
		sprite_2d.frame_coords = sprite_2d.frame_coords + Vector2i(1, 0)

func ice_pressed_effects() -> void:
	# TODO - Rotate sprite
	key_pressed_sound.play()

func break_ice() -> void:
	ice_broken.emit()
	key_broken_sound.play()
	await key_broken_sound.finished
	queue_free()
