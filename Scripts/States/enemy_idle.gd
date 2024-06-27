extends EnemyState
class_name EnemyIdle



func Update(_delta: float):
	# TODO add how the slime will move randomly
	enemy.velocity = Vector2.ZERO
	var direction = player.global_position - enemy.global_position
	if direction.length() <= 400:
		Transitioned.emit(self, "chase")
	enemy.animated_sprite_2d.play("walk")

