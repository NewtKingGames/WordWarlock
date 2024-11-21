class_name CastingTextChild extends Label
var letter_position_offset: float = 20


var should_hover: bool = false
@onready var max_y_hover: float = position.y + 5
@onready var min_y_hover: float = position.y - 5
var hover_direction: int = 1
var match_string_tween: Tween
# TODO - play around with these effects in the future

# On ready the text should pop up
func _ready():
	rotate_text_start()


func _physics_process(delta: float) -> void:
	if should_hover:
		position.y = position.y + (hover_direction * delta * 20) / Engine.time_scale
		position.y = clampf(position.y, min_y_hover, max_y_hover)
		if position.y == max_y_hover:
			hover_direction = -1
		if position.y == min_y_hover:
			hover_direction = 1

func other_letter_added_effect():
	slide_text_left()
	
func other_letter_removed_effect():
	slide_text_right()
	
func remove():
	queue_free()

func rotate_text_start():
	var tween_size: Tween = create_tween().parallel()
	var tween_rotate: Tween = create_tween()
	scale = Vector2(0.2, 0.2)
	tween_size.tween_property(self, "scale", Vector2(1.2, 1.2), 1 * Engine.time_scale).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	var max_rotation = randi_range(20, 30)
	var rotate_direction = randi_range(0, 1)
	if rotate_direction == 0:
		rotate_direction = -1
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * rotate_direction, 0.05 * Engine.time_scale)
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.05 * Engine.time_scale)
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * randf_range(0.3, 0.6) * rotate_direction * -1, 0.05 * Engine.time_scale)
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.05 * Engine.time_scale)
	tween_rotate.tween_property(self, "rotation_degrees", max_rotation * randf_range(0.1, 0.3) * rotate_direction, 0.05 * Engine.time_scale )
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.05 * Engine.time_scale)

func slide_text_left():
	slide_text(-1)

func slide_text_right():
	slide_text(1)
	
# 1 = rotate to the right -1 = rotate to the left
func slide_text(direction: int):
	var tween_rotate: Tween = create_tween()
	var tween_position: Tween = create_tween()
	var rotation = randi_range(15, 20)
	tween_rotate.tween_property(self, "rotation_degrees", rotation * direction, 0.1 * Engine.time_scale)
	tween_rotate.tween_property(self, "rotation_degrees", 0, 0.1 * Engine.time_scale)
	#tween_position.tween_property(self, "position", Vector2(position.x + letter_position_offset*direction, position.y), 0.1 * speed_offset)

func hover_text(delay_start: float):
	await get_tree().create_timer(delay_start*Engine.time_scale).timeout
	should_hover = true
	#match_string_tween = create_tween().set_loops()
	## TODO - Unfortunately doing this in a tween will result in som
	#e wonkiness when time slows/speeds up... Eventually move to process and stop using tweens
	#match_string_tween.tween_property(self, "position", Vector2(position.x, position.y + 5) , 0.5 * speed_offset)
	#match_string_tween.tween_property(self, "position", Vector2(position.x, position.y - 5) , 0.5 * speed_offset)

func stop_hover_text() -> void:
	position = Vector2(position.x, 0)
	if match_string_tween:
		match_string_tween.kill()
	should_hover = false
