extends State

@onready var player = $"../.."
@onready var character_animated_sprite = $"../../CharacterAnimatedSprite2D"


func Exit():
	player.taking_damage = false
	player.velocity = Vector2.ZERO

func Update(_delta: float):
	character_animated_sprite.play("damage")
	player.velocity = player.knockback_direction * player.knockback_speed


func _on_stunlock_timer_timeout():
	print("timeout!")
	Transitioned.emit(self, "idle")
