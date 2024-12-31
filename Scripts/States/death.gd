extends State
class_name PlayerDeathState

@onready var character_animated_sprite_2d = $"../../CharacterAnimatedSprite2D"
@onready var damage_noise: AudioStreamPlayer2D = $"../../Sounds/DamageNoise"
@onready var player = $"../.."

func Enter():
	damage_noise.play()
	player.velocity = Vector2.ZERO
	character_animated_sprite_2d.play("death")

