extends EnemyState
class_name EnemyDeath


func Enter():
	enemy.velocity = Vector2.ZERO
	enemy.animated_sprite_2d.play("death")
