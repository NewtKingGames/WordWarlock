extends Spell
class_name ProjectileSpell
# TODO - consider making this exports, having to exactly match the name might be annoying
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var point_light_2d = $PointLight2D

@export var spell_speed: float
@export var impact_sound: AudioStreamPlayer2D
@export var spell_damage: int
var direction: Vector2 = Vector2.ZERO


func _process(delta):
	position += direction*spell_speed*delta

# Called by the child classes, probably used with a on_body_entered
func spell_hit_body(body: Node2D):
	if body is EnemyClass:
		body.hit(10) # TODO add constant file with these values
	else:
		pass
	impact_sound.play()
	animated_sprite_2d.visible = false
	collision_shape_2d.disabled = true
	point_light_2d.visible = false
