extends Spell
class_name ProjectileSpell
# TODO - consider making this exports, having to exactly match the name might be annoying
@onready var collision_shape_2d = $CollisionShape2D
@onready var point_light_2d = $PointLight2D

@export var spell_speed: float
@export var impact_sound: AudioStreamPlayer2D
@export var spell_damage: int
var direction: Vector2 = Vector2.ZERO


func _process(delta):
	position += direction*spell_speed*delta

# Called by the child classes, usually called within a on_body_entered signal receiver
func spell_hit_body(body: Node2D):
	if body is EnemyClass:
		body.hit(spell_damage)
	else:
		pass
	impact_sound.pitch_scale = randf_range(0.6, 1.4)
	impact_sound.play()
