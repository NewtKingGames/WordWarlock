extends Node2D

@export var scene_to_take_player_to: PackedScene
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var teleport_area: Area2D = $TeleportArea
@onready var walk_up_area: Area2D = $WalkUpArea
@onready var unlock_label: Label = $UnlockLabel
@onready var unlock_noise: AudioStreamPlayer2D = $UnlockNoise
@onready var open_noise: AudioStreamPlayer2D = $OpenNoise

@export var unlock_text: String = "KNOCK"
var is_door_opened: bool = false

func _ready():
	unlock_label.text = unlock_text
	teleport_area.connect("body_entered", on_teleport_area_body_entered)
	walk_up_area.connect("body_entered", on_walk_up_area_body_entered)
	walk_up_area.connect("body_exited", on_walk_up_area_body_exited)
	#get_tree().get_first_node_in_group("player").connect("spell_string_cast", on_player_spell_cast_string)
	Events.player_entered_spell_string.connect(on_player_spell_cast_string)

func on_player_spell_cast_string(spell_text: String):
	if unlock_label.visible and unlock_text.to_upper() == spell_text.to_upper():
		Globals.transition_player_to_idle_state()
		unlock_noise.play()
		lower_door()

func on_teleport_area_body_entered(body: Node2D):
	take_player_to_new_scene()
	
func on_walk_up_area_body_entered(body: Node2D):
	unlock_label.visible = true
	# Play effects for the text

func on_walk_up_area_body_exited(body: Node2D):
	unlock_label.visible = false

func lower_door():
	if not is_door_opened:
		unlock_label.visible = false
		is_door_opened = true
		$StaticBody2D.queue_free()
		animated_sprite_2d.play("unlock")

func take_player_to_new_scene():
	if scene_to_take_player_to:
		GlobalCanvasLayer.change_scene(scene_to_take_player_to)
