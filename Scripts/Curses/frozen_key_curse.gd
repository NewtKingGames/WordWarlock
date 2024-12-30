class_name FrozenKeyCurse
extends Curse

# TODO - you should make sure that passing a reference of the scene tree to a resource
# is not problematic!!

func _init() -> void:
	name = "FROZEN KEYS"
	primary_color = Color("#7495F7")
	secondary_color = Color("#A874F7")
	

func start_curse(scene_tree: SceneTree) -> void:
	print(name)
	var keyboard: Keyboard = scene_tree.get_first_node_in_group("keyboard")
	if not Globals.is_player_casting:
		VisualUtils.fade_in_node(keyboard)
	for i in range(6):
		keyboard.freeze_random_key()
		await scene_tree.create_timer(1).timeout
	if not Globals.is_player_casting:
		VisualUtils.fade_out_node(keyboard)

func end_curse(scene_tree: SceneTree) -> void:
	# This could grab a reference to the keyboard and freeze a select amount of letters
	pass
