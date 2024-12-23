class_name Curse
extends Resource

# signal which will allow for some curses to end themselves
# You could use this with a timer on the base spell resource with some kind of TTL rather
# than an event ending the curse explicitly
signal end_self_curse

enum CURSE_TYPE {FROZEN_KEY}  

@export var name: String = ""


func start_curse(scene_tree: SceneTree) -> void:
	pass

func end_curse(scene_tree: SceneTree) -> void:
	pass
