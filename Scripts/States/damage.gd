extends State

@onready var player = $"../.."
@onready var character_animated_sprite = $"../../CharacterAnimatedSprite2D"
@onready var damage_noise: AudioStreamPlayer2D = $"../../Sounds/DamageNoise"

func Enter():
	# TODO - fix this audio player only playing audio track in left ear channel...
	damage_noise.play()

func Exit():
	player.taking_damage = false
	player.velocity = Vector2.ZERO

func Update(_delta: float):
	character_animated_sprite.play("damage")
	player.velocity = player.knockback_direction


func _on_stunlock_timer_timeout():
	print("timeout!")
	Transitioned.emit(self, "idle")
