extends EnemyState
class_name ChaseState

func Update(_delta):
	var direction: Vector2 = player.global_position - enemy.global_position
	if direction.length() > 100:
		Transitioned.emit(self, "idle")
	enemy.velocity = direction.normalized() * 30
