extends EnemyAttackState
class_name EnemyAttackProjectileState

func Enter():
	print("Entered attack")
	
func Update(delta: float):
	var vector_to_player: Vector2 = player.global_position - enemy.global_position
