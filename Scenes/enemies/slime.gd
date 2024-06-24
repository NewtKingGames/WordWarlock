extends EnemyClass
class_name Slime

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var walk_speed: float = 100

#func _ready():
	# No need for this right now, but this is sweet!!
	#super._ready()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Flip Sprite
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true
	animated_sprite_2d.play("walk")
	move_and_slide()
	


func _on_slime_attack_area_body_entered(body):
	# TODO - could reconsider having the attack be a state?
	if body is Player:
		body.hit(10, velocity.normalized())
