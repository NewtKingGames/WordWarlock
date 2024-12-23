class_name KeyboardLetter
extends Node2D

@onready var letter_sprite = $LetterSprite
@onready var letter_sprite_pressed = $LetterSpritePressed
# This get's set by the parent 'keyboard' upon initialization in set_keyboard_letter
@export var letter_string: String = ""
@export var letter_num: int

# TODO would be cool to implement a feature where letters could get jumbled around? if you want to do that you should probably differentiate between the "original_letter_string" and "current_letter_string"

var letter_active: bool = true:
	set(value): 
		if value == letter_active:
			return
		# TODO add more visual/audio effects?
		if value == false:
			modulate = Color.FIREBRICK
		if value == true:
			modulate = Color.WHITE
		letter_active = value

func _ready():
	letter_sprite.visible = true
	letter_sprite_pressed.visible = false
	# Allows for special keys
	if letter_string != "":
		set_keyboard_letter(letter_string, letter_num)
	## temporary random to test inactive letters
	#var random_num = randi_range(0, 1)
	#if random_num == 0:
		#letter_active = false
	#if random_num == 1:
		#letter_active = true

func set_keyboard_letter(letter: String, letter_num: int):
	letter_string = letter
	letter_sprite.set_frame_coords(Vector2i(letter_num % 8, 2 + letter_num/8))
	letter_sprite_pressed.set_frame_coords(Vector2i(letter_num % 8, 9 + letter_num/8))

func key_pressed() -> void:
	if not letter_active:
		return
	letter_sprite.visible = false
	letter_sprite_pressed.visible = true
	await get_tree().create_timer(0.2 * Globals.time_scale_offset).timeout
	letter_sprite.visible = true
	letter_sprite_pressed.visible = false

func key_pressed_stick_key() -> void:
	letter_sprite.visible = false
	letter_sprite_pressed.visible = true

func unstick_key() -> void:
	letter_sprite.visible = true
	letter_sprite_pressed.visible = false
