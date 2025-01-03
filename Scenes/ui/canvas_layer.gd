extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

# TODO - create some kind of class for 'Level Transition arguments'
# This should give context to this transitionary method on how to load the player into the next level
#

func change_scene(level_transition_context: LevelTransitionContext=null) -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	var tween_fade: Tween = create_tween()
	tween_fade.parallel().tween_property(Globals, "player_walk_speed", 0, .75) 
	tween_fade.parallel().tween_property(player, "modulate", Color(1,1,1,0), .6)
	tween_fade.parallel().tween_property(color_rect, "color", Color(0,0,0,1), .75)
	await tween_fade.finished
	var old_scene = get_tree().get_first_node_in_group("level")
	old_scene.free()
	var new_scene = level_transition_context.get_packed_level_scene().instantiate()
	if level_transition_context and "level_transition_context" in new_scene:
		new_scene.level_transition_context = level_transition_context
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	await get_tree().create_timer(.5).timeout
	var tween_fade_in: Tween = create_tween()
	tween_fade_in.tween_property($ColorRect, "color", Color(0,0,0,0), 1)
	Globals.player_walk_speed = Globals.player_base_walk_speed
