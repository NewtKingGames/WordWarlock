extends State
class_name Player_Idle

@onready var player = $"../.."
@onready var character_animated_sprite_2d = $"../../CharacterAnimatedSprite2D"

func Enter():
	character_animated_sprite_2d.play("idle")
	player.velocity = Vector2.ZERO

func Exit():
	character_animated_sprite_2d.stop()

func Handle_Input(input: InputEvent) -> void:
	if Input.get_vector("down","up","right","left"):
		Transitioned.emit(self, "move")
	elif input.is_action_pressed("enter"):
		Transitioned.emit(self, "cast")
