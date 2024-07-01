extends EnemyClass
class_name Orc

@onready var swing_area: Area2D = $SwingArea

func _physics_process(delta):
	super._physics_process(delta)


func orc_swing():
	print("orc swinging")
	# TODO check performance and consider changing this to use events
	if swing_area.overlaps_body(player):
		print("Hit player!")
		var direction: Vector2 = (player.global_position - global_position).normalized()
		player.hit(10, direction)
	else:
		print("missed player")
