extends Node
# TODO - would a dictionary work? I'm a bit worried about curses removing themselves from the active list...
var active_curses: Array[Curse] = []
# Future proofing in case we want to add any new curses
@export var active_curse_limit: int = 1
const CURSE_NOTIFY_VISUALS: PackedScene = preload("res://Scenes/ui/dialogue/curse_notify_visuals.tscn")
var player: Player

# TODO - NEED TO IMPLEMENT END CURSE BEHAVIOR

func _ready() -> void:
	Events.start_curse.connect(start_curse)

func start_curse(curse_type: Curse.CURSE_TYPE) -> void:
	var curse: Curse = _create_curse(curse_type)
	active_curses.append(curse)
	curse.start_curse(get_tree())
	var curse_notification: CurseNotifyVisuals = CURSE_NOTIFY_VISUALS.instantiate()
	curse_notification.curse = curse
	var player: Player = get_tree().get_first_node_in_group("player") as Player
	curse_notification.player = player
	add_child(curse_notification)

func _create_curse(curse_type: Curse.CURSE_TYPE) -> Curse:
	var curse: Curse
	if curse_type == Curse.CURSE_TYPE.FROZEN_KEY:
		curse = FrozenKeyCurse.new()
	if curse_type == Curse.CURSE_TYPE.BLIND_KEYS:
		curse = BlindKeyCurse.new()
	return curse
