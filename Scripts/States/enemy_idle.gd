extends EnemyState
class_name EnemyIdle

func Update(_delta: float):
	# Could add enemy random directions
	enemy.velocity = Vector2.ZERO
	var direction = player.global_position - enemy.global_position
	if direction.length() <= enemy.chase_distance:
		Transitioned.emit(self, "chase")
	enemy.animated_sprite_2d.play("idle")

