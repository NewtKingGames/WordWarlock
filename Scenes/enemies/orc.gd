extends EnemyClass
class_name Orc

@onready var swing_area: Area2D = $VisibleNodes/SwingArea

func _physics_process(delta):
	super._physics_process(delta)


func orc_swing():
	# TODO check performance and consider changing this to use events
	if swing_area.overlaps_body(player):
		var direction: Vector2 = (player.global_position - global_position).normalized()
		player.hit(10, direction*knock_back_magnitude)
