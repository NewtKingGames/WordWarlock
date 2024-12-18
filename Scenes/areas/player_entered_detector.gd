extends Area2D


signal player_entered
@export var is_one_shot: bool = false

func _ready()-> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit()
		if is_one_shot:
			queue_free()
