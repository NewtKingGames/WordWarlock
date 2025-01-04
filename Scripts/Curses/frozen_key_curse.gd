class_name FrozenKeyCurse
extends Curse

# TODO - you should make sure that passing a reference of the scene tree to a resource
# is not problematic!!

var keys_to_freeze: int = 10
var continually_freeze: bool = false

func _init() -> void:
	name = "FROZEN KEYS"
	curse_type = CURSE_TYPE.FROZEN_KEY
	primary_color = Color("#7495F7")
	secondary_color = Color("#A874F7")
	

func start_curse(scene_tree: SceneTree) -> void:
	print(name)
	var keyboard: Keyboard = scene_tree.get_first_node_in_group("keyboard") as Keyboard
	keyboard.freeze_keyboard()
	# New implementation:
	# Instead of freezing indidivual keys let's try freezing the entire keyboard and only once the player mashes the keyboard enough does it break free
	# you can probably reuse alot of your existing code
	# TODO - think about having some kind of better visualization for the keyboard curse
	##if not Globals.is_player_casting:
		##VisualUtils.fade_in_node(keyboard)
	#for i in range(6):
		#keyboard.freeze_random_key()
		#await scene_tree.create_timer(1).timeout
	##if not Globals.is_player_casting:
		##VisualUtils.fade_out_node(keyboard)

func end_curse(scene_tree: SceneTree) -> void:
	# This could grab a reference to the keyboard and freeze a select amount of letters
	pass
