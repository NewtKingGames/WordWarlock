class_name Spikes
extends Node2D
@onready var hurt_box: Area2D = $HurtBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hurt_box.monitoring = false
	hurt_box.body_entered.connect(_on_player_entered)

func activate_spikes() -> void:
	animation_player.play("activate_spikes")


func deactivate_spikes() -> void:
	animation_player.play("deactivate_spikes")

func _on_player_entered(node: Node2D) -> void:
	if node is Player:
		node.hit(1, Vector2.ZERO)

func _spikes_can_hurt() -> void:
	hurt_box.monitoring = true

func _spikes_cant_hurt() -> void:
	hurt_box.monitoring = false
