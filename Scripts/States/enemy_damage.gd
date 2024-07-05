extends EnemyState
class_name EnemyDamage

@onready var stunlock_timer = $"../../Timers/StunlockTimer"


func Enter():
	enemy.velocity = Vector2.ZERO
	enemy.animated_sprite_2d.play("damage")
	stunlock_timer.start()

func _on_stunlock_timer_timeout():
	var direction: Vector2 = player.global_position - enemy.global_position
	if direction.length() <= 400:
		Transitioned.emit(self, "chase")
	else:
		Transitioned.emit(self, "idle")
