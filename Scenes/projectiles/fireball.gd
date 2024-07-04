extends ProjectileSpell
class_name Fireball # This keeps reporting "Hidiing global script class" it resolves the error when I just retype it..

@onready var animated_sprite_2d = $AnimatedSprite2D

var has_hit: bool = false

func _on_body_entered(body: Node2D):
	if has_hit:
		return
	has_hit = true
	spell_hit_body(body)
	animated_sprite_2d.visible = false
	collision_shape_2d.disabled = true
	point_light_2d.visible = false

func _on_impact_noise_finished():
	queue_free()
