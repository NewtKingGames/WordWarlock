class_name FrozenKeyCurse
extends Curse

# TODO - you should make sure that passing a reference of the scene tree to a resource
# is not problematic!!

func start_curse(scene_tree: SceneTree) -> void:
	var keyboard: Keyboard = scene_tree.get_first_node_in_group("keyboard")
	print("do something against the keyboard")
	print(keyboard)
	for i in range(6):
		scene_tree.create_timer(i+1).timeout.connect(func(): _call_back_function(keyboard))
	pass

func _call_back_function(keyboard: Keyboard) -> void:
	print("pressing key!")
	keyboard.key_pressed("A")

func end_curse(scene_tree: SceneTree) -> void:
	# This could grab a reference to the keyboard and freeze a select amount of letters
	pass
