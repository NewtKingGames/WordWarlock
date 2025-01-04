class_name BlindKeyCurse
extends Curse



func _init() -> void:
	name = "BLIND KEYS"
	curse_type = CURSE_TYPE.BLIND_KEYS
	primary_color = Color("#A1A592")
	secondary_color = Color("#5C697A")
	

func start_curse(scene_tree: SceneTree) -> void:
	print(name)
	#var keyboard: Keyboard = scene_tree.get_first_node_in_group("keyboard")
	#if not Globals.is_player_casting:
		#VisualUtils.fade_in_node(keyboard)
	Events.player_blinded.emit(true)
	#for i in range(6):
		#keyboard.freeze_random_key()
		#await scene_tree.create_timer(1).timeout
	#if not Globals.is_player_casting:
		#VisualUtils.fade_out_node(keyboard)
	#Events.player_blinded.emit(false)

func end_curse(scene_tree: SceneTree) -> void:
	# This could grab a reference to the keyboard and freeze a select amount of letters
	pass
