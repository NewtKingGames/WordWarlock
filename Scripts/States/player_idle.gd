extends State
class_name Player_Idle

@onready var player = $"../.."
@onready var character_animated_sprite_2d = $"../../CharacterAnimatedSprite2D"

func Enter():
	character_animated_sprite_2d.play("idle")

func Exit():
	character_animated_sprite_2d.stop()
	
func Update(_delta: float):
	if Input.get_vector("down","up","right","left"):
		Transitioned.emit(self, "move")
	elif Input.is_action_just_pressed("enter"):
		Transitioned.emit(self, "cast")
	player.velocity = Vector2.ZERO
