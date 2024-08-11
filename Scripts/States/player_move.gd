extends State
class_name PlayerMove

@onready var player = $"../.."
@onready var character_animated_sprite_2d = $"../../CharacterAnimatedSprite2D"


func Enter():
	character_animated_sprite_2d.play("walk")
	
func Update(_delta: float):
	var direction = Input.get_vector("left", "right", "up", "down")
	player.velocity = direction * Globals.player_walk_speed
	if not direction:
		if Input.is_action_just_pressed("enter"):
			Transitioned.emit(self, "cast")
		else:
			Transitioned.emit(self, "idle")
	if player.velocity.x > 0:
		player.character_animated_sprite.flip_h = false
	elif player.velocity.x < 0:
		player.character_animated_sprite.flip_h = true

func Physics_Update(_delta: float):
	pass

