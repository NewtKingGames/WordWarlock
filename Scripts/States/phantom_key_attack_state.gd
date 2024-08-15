extends EnemyAttackState
class_name PhantomKeyAttackState

#var can_shoot: bool = true
@onready var ghost_alerted_sprite_2d = $"../../VisibleNodes/GhostAlertedSprite2D"

func Enter():
	enemy.velocity = Vector2.ZERO
	ghost_alerted_sprite_2d.visible = true
	enemy.animated_sprite_2d.play("attack")
	# Play some animation and then shoot out our projectile
	# Exit the state when either the projectile makes contact with the player or it hit's max distance
	# Transition to either 'Chase' or 'StoleKey'
	# I think for now these transitions can live in the top level parent script of the object?

func Exit():
	ghost_alerted_sprite_2d.visible = false

func Update(delta):
	pass
