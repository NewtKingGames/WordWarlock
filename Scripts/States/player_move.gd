extends State
class_name PlayerMove

@onready var player = $"../.."
@onready var character_animated_sprite_2d = $"../../CharacterAnimatedSprite2D"


func Enter():
	character_animated_sprite_2d.play("walk")
	
func Update(_delta: float):
	if Input.is_action_just_pressed("enter"):
		player.velocity = Vector2.ZERO
		Transitioned.emit(self, "cast")
		return
	var direction = Input.get_vector("left", "right", "up", "down")
	if player.input_enabled:
		player.velocity = direction * Globals.player_walk_speed
		if not direction:
			Transitioned.emit(self, "idle")
	#if not direction and player.input_enabled:
		
	if player.velocity.x > 0:
		player.character_animated_sprite.flip_h = false
	elif player.velocity.x < 0:
		player.character_animated_sprite.flip_h = true
