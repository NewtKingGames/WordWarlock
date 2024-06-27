extends EnemyState
class_name ChaseState

func Update(_delta):
	var direction: Vector2 = player.global_position - enemy.global_position
	if direction.length() > 400:
		Transitioned.emit(self, "idle")
	enemy.velocity = direction.normalized() * enemy.walk_speed
	enemy.animated_sprite_2d.play("walk")



func _on_slime_attack_area_body_entered(body: Node2D):
	if body is Player:
		body.hit(10, enemy.velocity.normalized())
		Transitioned.emit(self, "attack")
