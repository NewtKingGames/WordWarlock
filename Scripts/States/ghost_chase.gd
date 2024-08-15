extends ChaseState
class_name GhostChaseState

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


func Update(_delta):
	var vector_to_player: Vector2 = player.global_position - enemy.global_position
	if vector_to_player.length() > enemy.chase_distance:
		Transitioned.emit(self, "idle")
		return
	# Should probably type cast here
	if vector_to_player.length() <= enemy.attack_distance_to_enter:
		Transitioned.emit(self, "attack")
		return
	enemy.velocity = vector_to_player.normalized() * enemy.walk_speed
	enemy.animated_sprite_2d.play("chase")
