class_name Firespell # This keeps reporting "Hidiing global script class" it resolves the error when I just retype it.. TODO RENAME BACK TO Fireball
extends ProjectileSpell
# BIG BUMMER! Multi inheritance does NOT work correctly meaning pure "projectile spells" are not going to work!!!
# This is going to require some refactoring, check out https://www.reddit.com/r/godot/comments/15sp93v/problem_with_multiinheritance/

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
	
	
# Overrides
static func get_spell_color():
	return Color.BLUE_VIOLET
