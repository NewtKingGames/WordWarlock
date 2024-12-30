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
	var tween_rotate: Tween = create_tween()
	var max_rotation = randi_range(10, 20)
	var rotate_direction = randi_range(0, 1)
	if rotate_direction == 0:
		rotate_direction = -1
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * rotate_direction, 0.025 * Engine.time_scale)
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.025 * Engine.time_scale)
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * randf_range(0.3, 0.6) * rotate_direction * -1, 0.025 * Engine.time_scale)
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.025 * Engine.time_scale)
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * randf_range(0.1, 0.3) * rotate_direction, 0.025 * Engine.time_scale )
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.025 * Engine.time_scale)
	key_pressed_sound.play()
	Events.shake_screen.emit(2)

func break_ice() -> void:
	ice_broken.emit()
	key_broken_sound.play()
	get_tree().create_timer(0.1*Engine.time_scale).timeout.connect(func(): sprite_2d.visible = false)
	key_broken_sound.finished.connect(func(): queue_free)
