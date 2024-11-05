extends Area2D


@export var set_enabled: bool = true
@export var set_opposite_on_exit: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		# Disable spell stack
		Events.spell_stack_toggle_area_entered.emit(set_enabled)

func _on_body_exited(body: Node2D) -> void:
	if body is Player and set_opposite_on_exit:
		Events.spell_stack_toggle_area_entered.emit(!set_enabled)
