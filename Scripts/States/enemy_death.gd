extends EnemyState
class_name EnemyDeath


func Enter():
	enemy.velocity = Vector2.ZERO
	enemy.animated_sprite_2d.play("death")


func _on_animated_sprite_2d_animation_finished():
	enemy.queue_free()
