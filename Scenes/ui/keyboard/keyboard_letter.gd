class_name KeyboardLetter
extends Node2D


@onready var letter_sprite = $LetterSprite
@onready var letter_sprite_pressed = $LetterSpritePressed

func _ready():
	letter_sprite.visible = true
	letter_sprite_pressed.visible = false

func set_keyboard_letter(letter: String, letter_num: int):
	print(letter)
	letter_sprite.set_frame_coords(Vector2i(letter_num % 8, 2 + letter_num/8))
	letter_sprite_pressed.set_frame_coords(Vector2i(letter_num % 8, 9 + letter_num/8))
	print(letter_sprite.frame_coords)

func key_pressed():
	letter_sprite.visible = false
	letter_sprite_pressed.visible = true
	await get_tree().create_timer(.09).timeout
	letter_sprite.visible = true
	letter_sprite_pressed.visible = false
	
