extends EnemyState
class_name EnemyAttackState

# When the enemy attacks we simply want it to stop chasing the player for a moment of time

@onready var attack_cooldown_timer = $"../../Timers/AttackCooldownTimer"


func Enter():
	player.hit(10, enemy.velocity.normalized())
	enemy.velocity = Vector2.ZERO
	player.hit(10, enemy.velocity.normalized())
	attack_cooldown_timer.start()
	# TODO play some kind of animation to convey it hit you
	



func _on_attack_cooldown_timer_timeout():
	print("can attack again")
	# If the player is nearby transition to chase
	# If the player is somehow far away transition to idle
	var direction: Vector2 = player.global_position - enemy.global_position
	if direction.length() <= 400:
		Transitioned.emit(self, "chase")
	else:
		Transitioned.emit(self, "idle")
