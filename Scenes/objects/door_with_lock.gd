extends Node2D

@export var scene_to_take_player_to: PackedScene
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var teleport_area: Area2D = $TeleportArea
@onready var walk_up_area: Area2D = $WalkUpArea
var is_door_opened: bool = false

func _ready():
	teleport_area.connect("body_entered", on_teleport_area_body_entered)
	walk_up_area.connect("body_entered", on_walk_up_area_body_entered)

func on_teleport_area_body_entered(body: Node2D):
	take_player_to_new_scene()
	
func on_walk_up_area_body_entered(body: Node2D):
	lower_door()


func lower_door():
	if not is_door_opened:
		is_door_opened = true
		$StaticBody2D.queue_free()
		animated_sprite_2d.play("unlock")

func take_player_to_new_scene():
	if scene_to_take_player_to:
		GlobalCanvasLayer.change_scene(scene_to_take_player_to)
		#get_tree().change_scene_to_packed(scene_to_take_player_to)
