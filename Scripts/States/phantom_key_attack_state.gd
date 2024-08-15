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


# TODO - you might be able to delete ALL of this commented out code
#func Update(delta: float):
	#if can_shoot:
		#enemy.shoot_hands()
		#attack_cooldown_timer.start()
		#can_shoot = false

#func _on_ghost_attack_cooldown_timer_timeout():
	#print("ghost can attack again")
	#can_shoot = true
	#attack_cooldown_timer.start()
