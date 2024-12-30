extends CanvasLayer

func change_scene(target_scene: PackedScene) -> void:
	var player: Player = get_tree().get_first_node_in_group("player")
	var tween_fade: Tween = create_tween()
	tween_fade.parallel().tween_property(Globals, "player_walk_speed", 0, .75) 
	tween_fade.parallel().tween_property(player, "modulate", Color(1,1,1,0), .6)
	tween_fade.parallel().tween_property($ColorRect, "color", Color(0,0,0,1), .75)
	await tween_fade.finished
	await get_tree().create_timer(.5).timeout
	get_tree().change_scene_to_packed(target_scene)
	var tween_fade_in: Tween = create_tween()
	tween_fade_in.tween_property($ColorRect, "color", Color(0,0,0,0), 1)
	Globals.player_walk_speed = Globals.player_base_walk_speed
