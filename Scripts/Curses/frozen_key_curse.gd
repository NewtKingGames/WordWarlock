class_name FrozenKeyCurse
extends Curse

# TODO - you should make sure that passing a reference of the scene tree to a resource
# is not problematic!!

func start_curse(scene_tree: SceneTree) -> void:
	var keyboard: Keyboard = scene_tree.get_first_node_in_group("keyboard")
	print("do something against the keyboard")
	print(keyboard)
	for i in range(6):
		keyboard.freeze_random_key()
		await scene_tree.create_timer(1).timeout
	pass

func end_curse(scene_tree: SceneTree) -> void:
	# This could grab a reference to the keyboard and freeze a select amount of letters
	pass
