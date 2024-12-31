class_name FireAnimation
extends Node2D
# TODO - consider making a parent class which controls this like the spikes

enum FIRE_COLOR {ORANGE, BLUE, GREEN, PURPLE, WHITE}
@export var fire_color_enum: FIRE_COLOR = FIRE_COLOR.ORANGE


var fire_color_dict: Dictionary = {
	FIRE_COLOR.ORANGE: "orange",
	FIRE_COLOR.BLUE: "blue",
	FIRE_COLOR.GREEN: "green",
	FIRE_COLOR.PURPLE: "purple",
	FIRE_COLOR.WHITE: "white"
}

@onready var fire_animation: AnimatedSprite2D = $FireAnimation
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var hurt_box: Area2D = $HurtBox

func _ready() -> void:
	hurt_box.monitoring = false
	fire_animation.play("no_animation")
	point_light_2d.enabled = false
	## Temporary timer
	#await get_tree().create_timer(1).timeout
	fire_animation.animation_finished.connect(_on_animation_finished)
	## Temporary timerd
	#get_tree().create_timer(6).timeout.connect(func(): stop_fire())
	hurt_box.body_entered.connect(_on_body_entered_hurt_box)

func start_fire() -> void:
	hurt_box.monitoring = true
	point_light_2d.enabled = true
	#fire_animation.play("start_orange_four")
	fire_animation.play(_get_animation_name(fire_color_enum, "start"))

func stop_fire() -> void:
	hurt_box.monitoring = false
	fire_animation.play(_get_animation_name(fire_color_enum, "end"))

func _on_animation_finished() -> void:
	if fire_animation.animation == _get_animation_name(fire_color_enum, "start"):
		fire_animation.play(_get_animation_name(fire_color_enum, "loop"))
	elif fire_animation.animation == _get_animation_name(fire_color_enum, "end"):
		queue_free()

func light_effects() -> void:
	var light_flicker_tween: Tween = create_tween().set_loops()
	light_flicker_tween.tween_property(point_light_2d, "energy", randf_range(0.03, 0.2), randf_range(0.25, 1))
	light_flicker_tween.tween_property(point_light_2d, "energy", randf_range(0.8, 0.9), randf_range(0.25, 1))

func _on_body_entered_hurt_box(body: Node2D) -> void:
	if body is Player:
		var player = body as Player
		# TODO - tweak this knock back value
		player.hit(1, (player.global_position - global_position).normalized() * 300)


func _get_animation_name(fire_color: FIRE_COLOR, portion: String, number: String ="four") -> String:
	return "%s_%s_%s" % [portion, fire_color_dict[fire_color], number]
	
