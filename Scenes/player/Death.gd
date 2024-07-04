extends State
class_name PlayerDeathState

@onready var character_animated_sprite_2d = $"../../CharacterAnimatedSprite2D"
@onready var damage_noise: AudioStreamPlayer2D = $"../../Sounds/DamageNoise"

func Enter():
	damage_noise.play()
	character_animated_sprite_2d.play("death")
	print("GAME OVER")

