class_name CastingText extends Label


# We want to change this functionality to now be a parent of many text children. We'll need to move the children left every time a new key is added and move it
# right every time a new key is deleted
func set_casting_text(value):
	set_text(value)



# Temp code stolen from the game jam
func rotate_text():
	var tween_size: Tween = create_tween().parallel()
	var tween_rotate: Tween = create_tween()
	tween_size.tween_property(self, "scale", Vector2(1.2, 1.2), 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	var max_rotation = randi_range(20, 30)
	var rotate_direction = randi_range(0, 1)
	if rotate_direction == 0:
		rotate_direction = -1
	
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * rotate_direction, 0.05)
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.05)
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * randf_range(0.3, 0.6) * rotate_direction * -1, 0.05)
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.05)
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * randf_range(0.1, 0.3) * rotate_direction, 0.05)
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.05)
