extends EnemyClass
class_name FlyingBat

signal bat_spit(speed: float, direction: Vector2, position: Vector2)

var bat_spit_scene: PackedScene = load("res://Scenes/enemies/bat_spit.tscn")
# I believe we want the distance the player needs to exit to be larger
@export var attack_distance_to_enter: float
@export var attack_distance_to_exit: float
@export var bat_spit_speed: float

func shoot():
	var direction: Vector2 = player.global_position - global_position
	bat_spit.emit(bat_spit_speed, direction.normalized(), global_position)
	
