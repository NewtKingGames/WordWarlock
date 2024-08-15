extends EnemyState
class_name StoleKey

@onready var enemy_animation_player = $"../../EnemyAnimationPlayer"
@onready var ghost_rematerialize_with_key_2d = $"../../VisibleNodes/GhostRematerializeWithKey2D"
@onready var ghost_idle_stolen_key_2d = $"../../VisibleNodes/GhostIdleStolenKey2D"

var is_animation_finished: bool = false
var direction: Vector2
var speed_with_key: float

func Enter():
	is_animation_finished = false
	print("entered stole key state")
	ghost_rematerialize_with_key_2d.visible = true
	enemy_animation_player.play("rematerialize_key")
	var direction_callback: Tween = create_tween().set_loops()
	direction_callback.tween_callback(create_new_direction).set_delay(1)

func Exit():
	ghost_rematerialize_with_key_2d.visible = false
	$"../../LetterSprite".visible = false
	
func Update(delta):
	if is_animation_finished:
		enemy.velocity = speed_with_key * direction
		# Move the enemy in a random direction away from the player changing the angle frequently


func create_new_direction():
	# Grab the unit vector from the player towards the enemy
	var direction_away_from_player = player.global_position.direction_to(enemy.global_position)
	# rotate it randomly away from the player
	var random_rotation_degrees = randf_range(-100, 100)
	direction = direction_away_from_player.rotated(deg_to_rad(random_rotation_degrees))
	# Randomize the speed slightly as well
	speed_with_key = randf_range(enemy.walk_speed, enemy.walk_speed*1.5)



func _on_enemy_animation_player_animation_finished(anim_name: String):
	if anim_name == "rematerialize_key":
		is_animation_finished = true
		ghost_rematerialize_with_key_2d.visible = false
		ghost_idle_stolen_key_2d.visible = true
		enemy_animation_player.play("idle")
		$"../../LetterSprite".visible = true
