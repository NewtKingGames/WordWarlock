extends ColorRect

# TODO - think about deleting
func _ready() -> void:
	#var tween: Tween = create_tween()
	#set_shader_value(0)
	#tween.tween_method(set_shader_value, 0.0, 1.0, 1)
	Events.player_entered_casting_state.connect(_on_player_entered_slow_mo)

func set_shader_value(value: float) -> void:
	material.set_shader_parameter("radius", value)


func _on_player_entered_slow_mo() -> void:
	set_shader_value(0.8)
	#var tween: Tween = create_tween()
	#tween.tween_method(set_shader_value, 0.0, 1.0, 0.2)
