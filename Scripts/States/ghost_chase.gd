extends ChaseState
class_name GhostState

@onready var ghost_idle_no_key_2d = $"../../VisibleNodes/GhostIdleNoKey2D"
@onready var ghost_idle_stolen_key_2d = $"../../VisibleNodes/GhostIdleStolenKey2D"


func Enter():
	if enemy.has_key():
		ghost_idle_stolen_key_2d.visible = true
	else:
		ghost_idle_no_key_2d.visible = true

func Exit():
	ghost_idle_no_key_2d.visible = false
	ghost_idle_stolen_key_2d.visible = false
