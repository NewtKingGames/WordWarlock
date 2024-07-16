class_name KeyboardLetter
extends Node2D

@onready var letter_sprite = $LetterSprite
@onready var letter_sprite_pressed = $LetterSpritePressed
# This get's set by the parent 'keyboard' upon initialization in set_keyboard_letter
var letter_string: String = ""

# TODO would be cool to implement a feature where letters could get jumbled around? if you want to do that you should probably differentiate between the "original_letter_string" and "current_letter_string"

var letter_active: bool = false:
	set(value): 
		if value == letter_active:
			return
		if value == false:
			modulate = Color.FIREBRICK
			# TODO add visual/audio effects
			letter_active = false
		if value == true:
			modulate = Color.WHITE
			letter_active = true

func _ready():
	letter_sprite.visible = true
	letter_sprite_pressed.visible = false

func set_keyboard_letter(letter: String, letter_num: int):
	letter_string = letter
	letter_sprite.set_frame_coords(Vector2i(letter_num % 8, 2 + letter_num/8))
	letter_sprite_pressed.set_frame_coords(Vector2i(letter_num % 8, 9 + letter_num/8))

func key_pressed():
	if not letter_active:
		print("dead letter")
		print(letter_string)
		return
	letter_sprite.visible = false
	letter_sprite_pressed.visible = true
	await get_tree().create_timer(.09).timeout
	letter_sprite.visible = true
	letter_sprite_pressed.visible = false
