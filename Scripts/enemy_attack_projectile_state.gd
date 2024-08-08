extends EnemyAttackState
class_name EnemyAttackProjectileState # TODO you should rename this to the BatAttackState class, it's become very bat specific

var new_position: Vector2
var vector_from_player: Vector2
var angle_to_rotate_vector: float
var can_shoot: bool = true


func Enter():
	can_shoot = true
	enemy.velocity = Vector2.ZERO
	enemy.animated_sprite_2d.play("attack")
	$"../../Timers/SpitAttackCooldownTimer".start()
	angle_to_rotate_vector = randf_range(-.08, .08)
	
func Update(delta: float):
	vector_from_player = enemy.global_position - player.global_position
	# if vector_from_player magnitude is too low bump it
	# TODO probably worth fine tuning these values
	if abs(vector_from_player.length() - enemy.attack_distance_to_enter) > 12:
		vector_from_player = vector_from_player * 2
	new_position = player.global_position + vector_from_player.rotated(angle_to_rotate_vector)
	var vector_to_position: Vector2 = new_position - enemy.global_position
	enemy.velocity = vector_to_position.normalized() * enemy.walk_speed
	if can_shoot:
		enemy.shoot()
		can_shoot = false
	var vector_to_player: Vector2 = player.global_position - enemy.global_position
	if vector_to_player.length() > enemy.attack_distance_to_exit:
		Transitioned.emit(self, "chase")

func _on_spit_attack_cooldown_timer_timeout():
	can_shoot = true
	$"../../Timers/SpitAttackCooldownTimer".start()
