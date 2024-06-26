extends Node

signal stat_change
signal player_damage

var player_health: int = 30:
	set(value):
		if value < player_health:
			player_damage.emit()
			stat_change.emit()
			player_health = value
