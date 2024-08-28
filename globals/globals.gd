extends Node

signal stat_change
signal player_damage
signal player_health_change(player_health: int)
signal player_slowdown_pool_change(player_slowdown_pool: float)


# Controls how player spells are shot
var cast_spells_with_mouse: bool = false

var engine_slowdown_magnitude: float = 0.25

# TODO would this be easier if the player owned all of it?
var player_slowdown_pool: float = 100:
	set(value):
		# short circuit out for min and max values
		if value <= 0 and player_slowdown_pool != 0:
			player_slowdown_pool = 0
		elif value >= 100 and player_slowdown_pool != 100:
			player_slowdown_pool = 100
		else:
			player_slowdown_pool = value
		player_slowdown_pool_change.emit(player_slowdown_pool)


const player_base_walk_speed: float = 400
@export var player_walk_speed: float = player_base_walk_speed:
	set(value):
		if value > player_base_walk_speed:
			print("player is speeding up - add some fancy effects here")
		player_walk_speed = value
		

var player_health: int = 4:
	set(value):
		if player_health <= 0:
			return # Temporary check in order to prevent queuing multpile restarts
		# Previous implementation was for a system where enemies deal dynamic damage, for now the new UI is going to treat all enemy damage as the same
		if value < player_health:
			# For now, all incoming damage is 1
			player_health = player_health - 1
			player_damage.emit()
			player_health_change.emit(player_health)
			if player_health <= 0:
				print("Waiting 3 seconds and restarting game")
				await get_tree().create_timer(3).timeout
				get_tree().reload_current_scene()
				# Reset player health after restarting the game
				player_health = 4
				player_health_change.emit(player_health)
