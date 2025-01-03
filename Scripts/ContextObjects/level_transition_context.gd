class_name LevelTransitionContext
extends Resource

static var level_names_to_scenes: Dictionary = {
	LEVEL_NAME.HUB_LEVEL: load("res://Scenes/levels/hub_level.tscn"),
	LEVEL_NAME.TEST_LEVEL: load("res://Scenes/levels/test_level.tscn"),
	LEVEL_NAME.FIRST_LEVEL: load("res://Scenes/levels/second_level.tscn")
}
# TODO - consider having the resource accept the packed scene as well
enum LEVEL_NAME {HUB_LEVEL, TEST_LEVEL, FIRST_LEVEL}

enum TRANSITION_REASON {INITIAL_GAME_LOAD, LEVEL_COMPLETED, LEVEL_EXITED, PLAYER_DIED}

@export var level_name: LEVEL_NAME
@export var transition_reason: TRANSITION_REASON



func get_packed_level_scene() -> PackedScene:
	return level_names_to_scenes[level_name]
# other arguments?
