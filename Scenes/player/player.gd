extends CharacterBody2D

@onready var character_animated_sprite = $CharacterAnimatedSprite2D
const walk_speed: float = 120

func _physics_process(delta):
	
	# Flip Sprite
	if velocity.x > 0:
		character_animated_sprite.flip_h = false
	elif velocity.x < 0:
		character_animated_sprite.flip_h = true
	
	move_and_slide()
