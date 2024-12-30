class_name CastingTextChild extends Label
var letter_position_offset: float = 20

enum TEXT_IDLE_EFFECTS {NONE, SHAKE}
enum TEXT_INTRO_EFFECTS {ROTATE_IN, SLIDE_DOWN_IN}
@export var text_idle_effect: TEXT_IDLE_EFFECTS = TEXT_IDLE_EFFECTS.NONE
@export var text_intro_effect: TEXT_INTRO_EFFECTS = TEXT_INTRO_EFFECTS.ROTATE_IN


var should_hover: bool = false
@onready var max_y_hover: float = position.y + 4
@onready var min_y_hover: float = position.y - 4
var hover_direction: int = 1
var match_string_tween: Tween
# TODO - play around with these effects in the future

# Maybe the best solution to providing more casting text effects is to expose some properties like the following:
# entrance_effect: Enum - allows us to choose the type of effect the letter does when it enters.
# persistent effects: Enum - optionally allows us to constantly apply some effects to the letters like shake glow etc.
# for the letter shake for curses I could use some persistent effects which shake the letters and makes them glow certain sinister colors?

var shake_offset: Vector2
# On ready the text should pop up
func _ready():
	shake_offset = Vector2(randf_range(1, 3), randf_range(1, 3))
	shake_offset = shake_offset if randi_range(0,1) == 1 else -shake_offset
	#shake_offset = Vector2(1, 1)
	if text_intro_effect == TEXT_INTRO_EFFECTS.ROTATE_IN:
		rotate_text_start()
	elif text_intro_effect == TEXT_INTRO_EFFECTS.SLIDE_DOWN_IN:
		slam_down_text_start()
	if text_idle_effect == TEXT_IDLE_EFFECTS.SHAKE:
		shake_text()

func shake_text() -> void:
	position = position + shake_offset
	shake_offset = - shake_offset
	get_tree().create_timer(.05).timeout.connect(shake_text)

#func _process(delta: float) -> void:
	#if text_idle_effect == TEXT_IDLE_EFFECTS.SHAKE:
		#position = position + shake_offset
		#shake_offset = - shake_offset


func _physics_process(delta: float) -> void:
	if should_hover:
		position.y = position.y + (hover_direction * delta * 15) / Engine.time_scale
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

# TODO - need to think about slotting in different effects for different kinds of things
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

func slam_down_text_start() -> void:
	var tween_size: Tween = create_tween().parallel()
	#var tween_rotate: Tween = create_tween()
	var tween_shake: Tween = create_tween().parallel()
	scale = Vector2(1.2, 0)
	tween_size.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2 * Engine.time_scale).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)

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
