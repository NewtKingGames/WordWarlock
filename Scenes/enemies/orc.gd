extends EnemyClass
class_name Orc

func _process(delta):
	# Flip Sprite
	# TODO - we should flip the entire parent node rather than sprite for this character?
	if velocity.x > 0:
		enemy_sprite.flip_h = false
	elif velocity.x < 0:
		enemy_sprite.flip_h = true
	move_and_slide()
