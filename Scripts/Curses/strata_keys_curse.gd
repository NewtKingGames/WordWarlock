class_name StrataKeys
extends Curse


var keys_to_freeze: int = 10
var continually_freeze: bool = false

func _init() -> void:
	name = "←↓STRATA-KEYS↑→"
	curse_type = CURSE_TYPE.STRATA_KEYS
	primary_color = Color("#7495F7")
	secondary_color = Color("#A874F7")
	

func start_curse(scene_tree: SceneTree) -> void:
	print("starting strata-keys")

func end_curse(scene_tree: SceneTree) -> void:
	# This could grab a reference to the keyboard and freeze a select amount of letters
	pass
