extends State
class_name PlayerDeathState

@onready var character_animated_sprite_2d = $"../../CharacterAnimatedSprite2D"

func Enter():
	character_animated_sprite_2d.play("death")
	print("GAME OVER")

