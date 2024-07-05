extends EnemyState
class_name EnemyAttackState

# When the enemy attacks we simply want it to stop chasing the player for a moment of time
@onready var attack_cooldown_timer = $"../../Timers/AttackCooldownTimer"

func Enter():
	print("parent attack")
	player.hit(10, enemy.velocity.normalized() * enemy.knock_back_magnitude)
	enemy.velocity = Vector2.ZERO
	attack_cooldown_timer.start()

func _on_attack_cooldown_timer_timeout():
	# If the player is nearby transition to chase
	# If the player is somehow far away transition to idle
	var direction: Vector2 = player.global_position - enemy.global_position
	if direction.length() <= enemy.chase_distance:
		Transitioned.emit(self, "chase")
	else:
		Transitioned.emit(self, "idle")
