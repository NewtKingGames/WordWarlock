extends ChaseState 
class_name EnemyChaseProjectileState

func Enter():
	enemy.animated_sprite_2d.play("chase")

func Update(_delta):
	var vector_to_player: Vector2 = player.global_position - enemy.global_position
	if vector_to_player.length() > enemy.chase_distance:
		Transitioned.emit(self, "idle")
		return
	# Should probably type cast here
	if vector_to_player.length() <= enemy.attack_distance_to_enter:
		Transitioned.emit(self, "attack")
		return
	enemy.velocity = vector_to_player.normalized() * enemy.walk_speed
	enemy.animated_sprite_2d.play("chase")
