extends Control

@onready var player_health_progress_bar = $PlayerHealthProgressBar

func _ready():
	Globals.connect("player_health_change", on_player_heatlh_change)


func on_player_heatlh_change(health: int):)
	player_health_progress_bar.value = health
