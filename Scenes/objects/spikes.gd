class_name Spikes
extends Node2D
@onready var hurt_box: Area2D = $HurtBox
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	hurt_box.body_entered.connect(_on_player_entered)
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func activate_spikes() -> void:
	animated_sprite_2d.play("activate_spikes")

func deactivate_spikes() -> void:
	animated_sprite_2d.play("deactivate_spikes")

func _on_player_entered(node: Node2D) -> void:
	if node is Player:
		node.hit(1, Vector2.ZERO)

func _on_animation_finished() -> void:
	if animated_sprite_2d.animation == "activate_spikes":
		hurt_box.monitoring = true
	if animated_sprite_2d.animation == "deactivate_spikes":
		hurt_box.monitoring = false
