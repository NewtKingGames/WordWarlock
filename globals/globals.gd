extends Node

signal stat_change
signal player_damage

var player_health: int = 30:
	set(value):
		if player_health <= 0:
			return # Temporary check in order to prevent queuing multpile restarts
		if value < player_health:
			player_damage.emit()
			stat_change.emit()
			player_health = value
			if value <= 0:
				print("Waiting 3 seconds and restarting game")
				await get_tree().create_timer(3).timeout
				get_tree().reload_current_scene()
