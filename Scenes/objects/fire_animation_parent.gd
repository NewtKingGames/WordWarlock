@tool
class_name FireAnimationParent
extends Node2D
const FIRE_ANIMATION: PackedScene = preload("res://Scenes/areas/fire_animation.tscn")
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var start_fire_sound: AudioStreamPlayer2D = $start_fire_sound
@onready var end_fire_sound: AudioStreamPlayer2D = $end_fire_sound



var offset_x: int = 35
var offset_y: int = 63
var scale_light_x_per_flame: float = 0.5 # 0.375
var scale_light_y_per_flame: float = 0.62 # 0.583
var light_effect_tween: Tween

@export var num_fire_x: int = 0:
	set(num):
		num_fire_x = num
		_delete_all_fire()
		create_fire_children()
@export var num_fire_y: int = 0:
	set(num):
		num_fire_y = num
		_delete_all_fire()
		create_fire_children()
	
@export var fire_color_enum: FireAnimation.FIRE_COLOR = FireAnimation.FIRE_COLOR.ORANGE
var fire_color_to_light: Dictionary = {
	FireAnimation.FIRE_COLOR.ORANGE:Color("#ebb51e"),
	FireAnimation.FIRE_COLOR.BLUE:Color("#1a5db2")
}


func _ready() -> void:
	# Only run this ready function when scene is loaded outside of the editor
	if not Engine.is_editor_hint():
		create_fire_children()

func start_fires() -> void:
	for fire_child in get_children():
		if fire_child is FireAnimation:
			fire_child.start_fire()
	set_light_properties()
	start_fire_sound.play()

func stop_fires() -> void:
	for fire_child in get_children():
		if fire_child is FireAnimation:
			fire_child.stop_fire()
	end_fire_sound.play()
	stop_light_effects()

func create_fire_children() -> void:
	var fire_position: Vector2 = position
	for x in range(num_fire_x):
		for y in range(num_fire_y):
			var fire: FireAnimation = FIRE_ANIMATION.instantiate()
			fire.position = Vector2(offset_x*x, offset_y*y)
			fire.fire_color_enum = fire_color_enum
			add_child(fire)
			if Engine.is_editor_hint():
				fire.owner = self

func set_light_properties() -> void:
	point_light_2d.enabled = true
	# TODO - I'm subtracting a bit to the left to center it but this is hacky
	var position: Vector2 = Vector2(offset_x*num_fire_x/2-18, offset_y*num_fire_y/2)
	point_light_2d.position = position
	point_light_2d.scale = Vector2(scale_light_x_per_flame*num_fire_x, scale_light_y_per_flame*num_fire_y)
	point_light_2d.color = fire_color_to_light[fire_color_enum]
	start_fire_sound.position = position
	end_fire_sound.position = position
	light_effects()

func light_effects() -> void:
	if light_effect_tween:
		light_effect_tween.kill()
	light_effect_tween = create_tween().set_loops()
	light_effect_tween.tween_property(point_light_2d, "energy",0.6, 0.6)
	light_effect_tween.tween_property(point_light_2d, "energy", 1.5, 0.9)
	#light_flicker_tween.tween_property(point_light_2d, "energy", randf_range(0.8, 1.4), randf_range(0.25, 1))
	#light_flicker_tween.tween_property(point_light_2d, "energy", randf_range(0.2, 0.6), randf_range(0.25, 1))
	#light_flicker_tween.tween_property(point_light_2d, "energy", randf_range(0.8, 1.4), randf_range(0.25, 1))

func stop_light_effects() -> void:
	if light_effect_tween:
		light_effect_tween.kill()
	light_effect_tween = create_tween()
	light_effect_tween.tween_property(point_light_2d, "energy",0.0, 0.25)
	
func _delete_all_fire() -> void:
	for child in get_children():
		if child is FireAnimation:
			child.queue_free()
