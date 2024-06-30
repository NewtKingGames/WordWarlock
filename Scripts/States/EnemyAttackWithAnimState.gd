extends EnemyAttackState
class_name EnemyAttackWithAnimState

func Enter():
	enemy.velocity = Vector2.ZERO
	attack_cooldown_timer.start()
	enemy.animated_sprite_2d.play("attack")

func _on_attack_cooldown_timer_timeout():
	print("within the extending class")
	# If the player is nearby transition to chase
	# If the player is somehow far away transition to idle
	var direction: Vector2 = player.global_position - enemy.global_position
	if direction.length() <= 400:
		Transitioned.emit(self, "chase")
	else:
		Transitioned.emit(self, "idle")
