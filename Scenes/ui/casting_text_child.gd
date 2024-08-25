class_name CastingTextChild extends Label
var letter_position_offset: float = 20
var speed_offset: float = Engine.time_scale

# TODO - play around with these effects in the future

# On ready the text should pop up
func _ready():
	rotate_text_start()

func other_letter_added_effect():
	slide_text_left()
	
func other_letter_removed_effect():
	slide_text_right()
	
func remove():
	queue_free()

# Temp code stolen from the game jam
func rotate_text_start():
	var tween_size: Tween = create_tween().parallel()
	var tween_rotate: Tween = create_tween()
	tween_size.tween_property(self, "scale", Vector2(1.2, 1.2), 1 * speed_offset).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	var max_rotation = randi_range(20, 30)
	var rotate_direction = randi_range(0, 1)
	if rotate_direction == 0:
		rotate_direction = -1
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * rotate_direction, 0.05 * speed_offset)
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.05 * speed_offset)
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * randf_range(0.3, 0.6) * rotate_direction * -1, 0.05 * speed_offset)
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.05 * speed_offset)
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * randf_range(0.1, 0.3) * rotate_direction, 0.05 * speed_offset )
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.05 * speed_offset)

func slide_text_left():
	slide_text(-1)

func slide_text_right():
	slide_text(1)
	
# 1 = rotate to the right -1 = rotate to the left
func slide_text(direction: int):
	var tween_rotate: Tween = create_tween()
	var tween_position: Tween = create_tween()
	var rotation = randi_range(15, 20)
	tween_rotate.tween_property(self, "rotation_degrees", rotation * direction, 0.1 * speed_offset)
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.1 * speed_offset)
	#tween_position.tween_property(self, "position", Vector2(position.x + letter_position_offset*direction, position.y), 0.1 * speed_offset)
