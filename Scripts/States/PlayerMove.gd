extends State
class_name PlayerMove

@onready var player = $"../.."
@onready var character_animated_sprite_2d = $"../../CharacterAnimatedSprite2D"


func Enter():
	print("Entering move state")
	character_animated_sprite_2d.play("walk")

func Exit():
	print("Exiting move")
	
func Update(_delta: float):
	var direction = Input.get_vector("left", "right", "up", "down")
	player.velocity = direction * player.walk_speed
	if not direction:
		Transitioned.emit(self, "idle")

func Physics_Update(_delta: float):
	pass

