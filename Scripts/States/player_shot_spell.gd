extends State
class_name PlayerShotSpellState

@onready var player = $"../.."
@onready var character_animated_sprite_2d = $"../../CharacterAnimatedSprite2D"


func Enter():
	character_animated_sprite_2d.play("shoot_spell")
	await character_animated_sprite_2d.animation_finished
	Transitioned.emit(self, "idle")
	
func Update(_delta: float):
	var direction = Input.get_vector("left", "right", "up", "down")
	player.velocity = direction * Globals.player_walk_speed * .66
	# Update the player to look towards the enemy the player is shooting at?

func Physics_Update(_delta: float):
	pass
