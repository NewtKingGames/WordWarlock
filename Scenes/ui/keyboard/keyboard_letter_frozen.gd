class_name KeyboardLetterFrozen
extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var key_pressed_sound: AudioStreamPlayer2D = $KeyPressedSound
@onready var key_broken_sound: AudioStreamPlayer2D = $KeyBrokenSound
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

signal ice_broken

var current_hits = 0 : 
	set(value):
		current_hits = value
		if value == hits_to_break:
			break_ice()
		else: 
			ice_pressed_effects()
@export var hits_to_break: int = 50

# We have a total of 5 frames in the break meaning we have 0->25% 25%->50% 50-75-75-99 100
func key_pressed() -> void:
	if current_hits < hits_to_break:
		current_hits += 1
		_set_key_frame(current_hits)
		#sprite_2d.frame_coords = sprite_2d.frame_coords + Vector2i(1, 0)

func _set_key_frame(current_hits: int) -> void:
	var percentage_through_hits: float = (1.0*current_hits)/(1.0*hits_to_break)
	if percentage_through_hits >= 0.25 and percentage_through_hits < 0.5 and sprite_2d.frame_coords != Vector2i(1, 2):
		sprite_2d.frame_coords = Vector2i(1, 2)
		key_pressed_sound.play()
		Events.shake_screen.emit(2)
	elif percentage_through_hits >= 0.5 and percentage_through_hits < 0.75 and sprite_2d.frame_coords != Vector2i(2, 2):
		sprite_2d.frame_coords = Vector2i(2, 2)
		key_pressed_sound.play()
		Events.shake_screen.emit(2)
	elif percentage_through_hits >= 0.75 and percentage_through_hits < 1 and sprite_2d.frame_coords != Vector2i(3, 2):
		sprite_2d.frame_coords = Vector2i(3, 2)
		key_pressed_sound.play()
		Events.shake_screen.emit(2)
	elif percentage_through_hits >=1 and sprite_2d.frame_coords != Vector2i(4, 2):
		sprite_2d.frame_coords = Vector2i(4, 2)
		key_broken_sound.play()
		Events.shake_screen.emit(7)

func ice_pressed_effects() -> void:
	# TODO - Rotate sprite
	var tween_rotate: Tween = create_tween()
	var max_rotation = randi_range(2, 25)
	var rotate_direction = randi_range(0, 1)
	if rotate_direction == 0:
		rotate_direction = -1
	#var tween_time: float = 0.025
	var tween_time: float = randf_range(0.01, 0.1)
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * rotate_direction, tween_time * Engine.time_scale)
	tween_time = randf_range(0.01, 0.05)
	tween_rotate.tween_property(self, "rotation_degrees", 0, tween_time * Engine.time_scale)
	tween_time = randf_range(0.01, 0.05)
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * randf_range(0.3, 0.6) * rotate_direction * -1, tween_time * Engine.time_scale)
	tween_time = randf_range(0.01, 0.05)
	tween_rotate.tween_property(self, "rotation_degrees", 0, tween_time * Engine.time_scale)
	tween_time = randf_range(0.01, 0.05)
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * randf_range(0.1, 0.3) * rotate_direction, tween_time * Engine.time_scale )
	tween_time = randf_range(0.01, 0.05)
	tween_rotate.tween_property(self, "rotation_degrees", 0, tween_time * Engine.time_scale)
	#key_pressed_sound.play()
	#Events.shake_screen.emit(2)

func break_ice() -> void:
	ice_broken.emit()
	#key_broken_sound.play()
	get_tree().create_timer(0.1*Engine.time_scale).timeout.connect(func(): sprite_2d.visible = false)
	cpu_particles_2d.speed_scale = cpu_particles_2d.speed_scale * (1 / Engine.time_scale)
	cpu_particles_2d.emitting = true
	key_broken_sound.finished.connect(func(): queue_free)
