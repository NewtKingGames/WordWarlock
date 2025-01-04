class_name Curse
extends Resource

# signal which will allow for some curses to end themselves
# You could use this with a timer on the base spell resource with some kind of TTL rather
# than an event ending the curse explicitly
signal end_self_curse

enum CURSE_TYPE {FROZEN_KEY, BLIND_KEYS, STRATA_KEYS}  

@export var name: String = ""
var curse_type: CURSE_TYPE
var primary_color: Color
var secondary_color: Color

func start_curse(scene_tree: SceneTree) -> void:
	pass

func end_curse(scene_tree: SceneTree) -> void:
	pass
