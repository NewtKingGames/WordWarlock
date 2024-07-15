extends Control

@onready var player_time_slow_progress_bar = $PlayerTimeSlowProgressBar

var player: Player

func _ready():
	Globals.connect("player_slowdown_pool_change", _on_player_slow_down_power_change)

func _on_player_slow_down_power_change(value: float):
	player_time_slow_progress_bar.value = value
