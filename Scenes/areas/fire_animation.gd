class_name FireAnimation
extends Node2D
# TODO - consider making a parent class which controls this like the spikes

@onready var fire_animation: AnimatedSprite2D = $FireAnimation
@onready var point_light_2d: PointLight2D = $PointLight2D


func _ready() -> void:
	point_light_2d.enabled = false
	await get_tree().create_timer(1).timeout
	fire_animation.animation_finished.connect(_on_animation_finished)
	point_light_2d.enabled = true
	fire_animation.play("start_orange_four")
	get_tree().create_timer(6).timeout.connect(func(): stop_fire())

func stop_fire() -> void:
	fire_animation.play("end_orange_four")

func _on_animation_finished() -> void:
	if fire_animation.animation == "start_orange_four":
		fire_animation.play("loop_orange_four")
	elif fire_animation.animation == "end_orange_four":
		queue_free()

func light_effects() -> void:
	var light_flicker_tween: Tween = create_tween().set_loops()
	light_flicker_tween.tween_property(point_light_2d, "energy", randf_range(0.03, 0.2), randf_range(0.25, 1))
	light_flicker_tween.tween_property(point_light_2d, "energy", randf_range(0.8, 0.9), randf_range(0.25, 1))
