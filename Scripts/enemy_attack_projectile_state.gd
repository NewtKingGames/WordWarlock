extends EnemyAttackState
class_name EnemyAttackProjectileState

func Enter():
	enemy.velocity = Vector2.ZERO
	enemy.animated_sprite_2d.play("attack")
	
func Update(delta: float):
	var vector_to_player: Vector2 = player.global_position - enemy.global_position
	#if vector_to_player.length() > enemy.attack_distance_to_exit:
		#print("returning to chase!")
		#Transitioned.emit(self, "chase")
	
