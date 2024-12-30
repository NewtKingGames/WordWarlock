extends Node

signal stat_change
signal player_damage
signal player_health_change(player_health: int)
signal player_slowdown_pool_change(player_slowdown_pool: float)

var engine_slowdown_magnitude: float = 0.25
# Convenience value to allow me to have animations that speed up as necessary when we're in the slow down effect
var time_scale_offset: float = 1 

var is_player_casting: bool = false
var current_player_typed_string: String = "": 
	set(value):
		current_player_typed_string = value
		if current_player_typed_string != "":
			Events.current_string_typed.emit(current_player_typed_string)

func _ready() -> void:
	Events.player_entered_casting_state.connect(_on_player_entered_casting)
	Events.player_exited_casting_state.connect(_on_player_exited_casting)


# Global function to allow certain actions to kick the player out of certain states
func transition_player_to_idle_state() -> void:
	var player: Player = get_tree().get_first_node_in_group("player") as Player
	if not player:
		return
	player.state_machine.on_outside_transition("idle")

# TODO - move engine time scale logic here
func _on_player_entered_casting() -> void:
	is_player_casting = true
	time_scale_offset = engine_slowdown_magnitude

func _on_player_exited_casting() -> void:
	is_player_casting = false
	time_scale_offset = 1

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
				await get_tree().create_timer(3).timeout
				get_tree().reload_current_scene()
				# Reset player health after restarting the game
				player_health = 4
				player_health_change.emit(player_health)
