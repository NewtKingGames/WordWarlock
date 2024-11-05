extends Node2D

@export var modulate_color: Color = Color.WHITE
@onready var point_light_2d = $PointLight2D

var max_torch_energy: float = randf_range(0.25, 0.35)
var min_torch_energy: float = randf_range(0.05, 0.15)
var initial_torch_energy: float = randf_range(min_torch_energy, max_torch_energy)

# The goal of this is replicate the animation player lighting effect, but in code so that you can randomize it
func _ready():
	modulate = modulate_color
	point_light_2d.color = modulate_color
	point_light_2d.energy = initial_torch_energy
	animate_lights()

func animate_lights():
	var light_flicker_tween: Tween = create_tween().set_loops()
	light_flicker_tween.tween_property(point_light_2d, "energy", randf_range(0.03, 0.2), randf_range(0.25, 1))
	light_flicker_tween.tween_property(point_light_2d, "energy", randf_range(0.3, 0.4), randf_range(0.25, 1))
