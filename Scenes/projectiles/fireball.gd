extends Area2D # TODO create a spell base class and extend here
class_name Fireball

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var point_light_2d = $PointLight2D
@onready var impact_noise = $ImpactNoise

var has_hit: bool = false


var direction: Vector2 = Vector2.UP
@export var speed: float = 200

func _process(delta):
	position += direction*speed*delta

func _on_body_entered(body: Node2D):
	if has_hit:
		return
	has_hit = true
	print("Fireball hit something!")
	if body is EnemyClass:
		print("Hit enemy!")
		body.hit(10) # TODO add constant file with these values
	else:
		print("structure")
	# disable properties, play explosion stuff then delete the object
	impact_noise.play()
	animated_sprite_2d.visible = false
	collision_shape_2d.disabled = true
	point_light_2d.visible = false

# Relying on impact noise finishing for now, better to use an animation
func _on_impact_noise_finished():
	queue_free()
