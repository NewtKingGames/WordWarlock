extends Control

@onready var player_time_slow_progress_bar = $PlayerTimeSlowProgressBar

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	# Connect signal

func on_player_slow_down_power_change(value: float):
	player_time_slow_progress_bar.value = value
