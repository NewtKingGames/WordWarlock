extends EnemyAttackState
class_name EnemyAttackWithAnimState

func Enter():
	enemy.velocity = Vector2.ZERO
	attack_cooldown_timer.start()
	enemy.animated_sprite_2d.play("attack")

func _on_attack_cooldown_timer_timeout():
	# TODO consider tracking the player being close to the player either through signals and booleans or just using pixels directly
	if enemy.attack_area.overlaps_body(player):
		Transitioned.emit(self, "attack")
	else:
		var direction: Vector2 = player.global_position - enemy.global_position
		if direction.length() <= 400:
			Transitioned.emit(self, "chase")
		else:
			Transitioned.emit(self, "idle")
