# Reconsider this being a singleton and instead consider having this be a static class
# which accepts the tweens instead of constructing them??
#class_name VisualUtils
extends Node

func fade_in_node(node: Node2D, duration: float=1.0) -> void:
	print(duration)
	var tween: Tween = create_tween()
	modulate_node(node, duration, Color(1,1,1,1), tween)

func fade_out_node(node: Node2D, duration: float =1.0) -> void:
	var tween: Tween = create_tween()
	modulate_node(node, duration, Color(1,1,1,0), tween)

func fade_in_out_node(node: Node2D, fade_in_duration: float=1.0, fade_out_duration: float=1.0) -> void:
	var tween: Tween = create_tween()
	modulate_node(node, fade_in_duration, Color(1,1,1,1), tween)
	await tween.finished
	tween = create_tween()
	modulate_node(node, fade_out_duration, Color(1,1,1,0), tween)
	

func modulate_node(node: Node2D, duration: float, target_color: Color, tween: Tween) -> void:
	tween.tween_property(node, "modulate", target_color, duration)
