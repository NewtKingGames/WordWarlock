extends Line2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	remove_point(1)
	add_point(get_local_mouse_position())
