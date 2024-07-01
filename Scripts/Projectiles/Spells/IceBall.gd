extends ProjectileSpell
class_name IceBall

# This spell is just going to be a simple Area2D which rotates itself


func _on_body_entered(body):
	# TODO call parent method, but we need to figure out how to let the animation here finish out first before the parent function disables the visuals
	if body is EnemyClass:
		print("Hit an enemy")
	else:
		print("hit something else")
	animated_sprite_2d.play("impact")
