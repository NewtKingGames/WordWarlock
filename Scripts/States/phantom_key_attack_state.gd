extends EnemyAttackState
class_name PhantomKeyAttackState

var can_shoot: bool = true

func Enter():
	print("entered attack state")
	# Play some animation and then shoot out our projectile
	# Exit the state when either the projectile makes contact with the player or it hit's max distance
	# Transition to either 'Chase' or 'StoleKey'
	# I think for now these transitions can live in the top level parent script of the object?


func Update(delta: float):
	if can_shoot:
		enemy.shoot_hands()
		attack_cooldown_timer.start()
		can_shoot = false

func _on_ghost_attack_cooldown_timer_timeout():
	print("ghost can attack again")
	can_shoot = true
	attack_cooldown_timer.start()
