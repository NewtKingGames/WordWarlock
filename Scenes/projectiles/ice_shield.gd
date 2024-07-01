extends Spell
class_name IceShield


@onready var ice_balls: Node2D = $IceBalls
@onready var ice_ball_spawn: Marker2D = $IceBallSpawn


# TODO - I wonder if using load makes sense
var ice_ball_scene: PackedScene = preload("res://Scenes/projectiles/ice_ball.tscn")



func _ready():
	# Initiate spawning of ice balls
	spawn_ice_ball(ice_ball_spawn.position)
	print("spawning ice ball!")
	#super.ready()?
	pass
	
func _update(delta):
	# Simply rotate the whole game object and delete this game object if all balls are gone
	pass


func spawn_ice_ball(position: Vector2):
	var ice_ball: IceBall = ice_ball_scene.instantiate()
	ice_ball.position = position
	ice_balls.add_child(ice_ball)
