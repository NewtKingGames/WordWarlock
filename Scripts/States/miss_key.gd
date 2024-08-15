extends EnemyState
class_name MissKey
@onready var ghost_idle_no_key_2d = $"../../VisibleNodes/GhostIdleNoKey2D"

# TODO - add some kind of confusion mark over the ghost when it misses

var seconds_ghost_waits: float = 1.5
var seconds_ghost_waited: float

func Enter():
	seconds_ghost_waited = 0
	ghost_idle_no_key_2d.visible = true
	enemy.animated_sprite_2d.play("idle")

func Exit():
	ghost_idle_no_key_2d.visible = false
	
func Update(delta):
	seconds_ghost_waited += delta
	if seconds_ghost_waited > seconds_ghost_waits:
		Transitioned.emit(self, "chase")
