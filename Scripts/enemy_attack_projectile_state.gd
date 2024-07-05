extends EnemyAttackState
class_name EnemyAttackProjectileState

var can_shoot: bool = true
func Enter():
	can_shoot = true
	enemy.velocity = Vector2.ZERO
	enemy.animated_sprite_2d.play("attack")
	$"../../Timers/SpitAttackCooldownTimer".start()
	
func Update(delta: float):
	if can_shoot:
		enemy.shoot()
		can_shoot = false
	var vector_to_player: Vector2 = player.global_position - enemy.global_position
	if vector_to_player.length() > enemy.attack_distance_to_exit:
		Transitioned.emit(self, "chase")

func _on_spit_attack_cooldown_timer_timeout():
	can_shoot = true
	$"../../Timers/SpitAttackCooldownTimer".start()
