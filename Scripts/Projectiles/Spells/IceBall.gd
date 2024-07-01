extends ProjectileSpell
class_name IceBall


signal ice_ball_destroyed()

# Used in IceShield spell
var has_hit: bool = false

func _on_body_entered(body):
	if has_hit:
		return
	has_hit = true
	spell_hit_body(body)
	animated_sprite_2d.play("impact")
	collision_shape_2d.disabled = true
	point_light_2d.visible = false


func _on_animated_sprite_2d_animation_finished():
	ice_ball_destroyed.emit()
	queue_free()
