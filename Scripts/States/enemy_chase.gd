extends EnemyState
class_name ChaseState # TODO this name isn't consistent

func Update(_delta):
	var direction: Vector2 = player.global_position - enemy.global_position
	if direction.length() > enemy.chase_distance:
		Transitioned.emit(self, "idle")
	enemy.velocity = direction.normalized() * enemy.walk_speed
	enemy.animated_sprite_2d.play("chase")




func _on_attack_area_body_entered(body: Node2D):
	if body is Player:
		Transitioned.emit(self, "attack")
