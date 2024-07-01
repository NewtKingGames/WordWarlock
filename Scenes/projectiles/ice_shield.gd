extends Spell
class_name IceShield

@export var num_ice_balls_spawn: int
# This should be set to AnimationPlayer duration / num_ice_balls_spawn
var ice_ball_spawn_delay: float = 0.3333

@onready var ice_balls: Node2D = $IceBalls
@onready var ice_ball_spawn: Marker2D = $IceBallSpawn

var ice_ball_scene: PackedScene = preload("res://Scenes/projectiles/ice_ball.tscn")

func _ready():
	# Initiate spawning of ice balls
	spawn_ice_balls(ice_ball_spawn.position)
	#super.ready()?
	pass
	
func _update(delta):
	# Simply rotate the whole game object and delete this game object if all balls are gone
	pass


func spawn_ice_balls(position: Vector2):
	# Delay after spawning each ice ball
	for n in num_ice_balls_spawn:
		spawn_ice_ball(position)
		await get_tree().create_timer(ice_ball_spawn_delay).timeout

func spawn_ice_ball(position: Vector2):
	var ice_ball: IceBall = ice_ball_scene.instantiate()
	ice_ball.position = ice_ball_spawn.position.rotated(-ice_balls.rotation)
	#ice_ball.rotate
	# I think we might be able to rotate the Vector2 by NEGATIVE the overall rotation of IceBalls
	ice_ball.connect("ice_ball_destroyed", on_ice_ball_destroyed)
	ice_balls.add_child(ice_ball)
	
func on_ice_ball_destroyed():
	num_ice_balls_spawn -= 1
	if num_ice_balls_spawn == 0:
		queue_free()
