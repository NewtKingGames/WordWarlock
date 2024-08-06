extends EnemyState
class_name EnemyDeath


func Enter():
	enemy.velocity = Vector2.ZERO
	if is_instance_of(enemy, Slime):
		# Randomize death animation for slime
		if randi_range(0, 1) == 1:
			enemy.animated_sprite_2d.play("death")
		else:
			enemy.animated_sprite_2d.play("death_two")
		return
	enemy.animated_sprite_2d.play("death")
