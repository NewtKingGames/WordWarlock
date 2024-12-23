extends Node
# TODO - would a dictionary work? I'm a bit worried about curses removing themselves from the active list...
var active_curses: Array[Curse] = []
# Future proofing in case we want to add any new curses
@export var active_curse_limit: int = 1

func _ready() -> void:
	Events.start_curse.connect(_start_curse)
	get_tree().create_timer(2).timeout.connect(func(): _start_curse(Curse.CURSE_TYPE.FROZEN_KEY))

func _start_curse(curse_type: Curse.CURSE_TYPE) -> void:
	var curse: Curse = _create_curse(curse_type)
	active_curses.append(curse)
	curse.start_curse(get_tree())

func _create_curse(curse_type: Curse.CURSE_TYPE) -> Curse:
	var curse: Curse
	if curse_type == Curse.CURSE_TYPE.FROZEN_KEY:
		curse = FrozenKeyCurse.new()
	return curse
