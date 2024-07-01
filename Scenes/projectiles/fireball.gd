extends ProjectileSpell
class_name Fireball

var has_hit: bool = false


func _on_body_entered(body: Node2D):
	if has_hit:
		return
	has_hit = true
	spell_hit_body(body)

# Relying on impact noise finishing for now, better to use an animation
func _on_impact_noise_finished():
	queue_free()
