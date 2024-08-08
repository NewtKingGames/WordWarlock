extends Sprite2D
class_name LetterSprite

func set_letter_string(letter_string: String):
	var letter_num: int = letter_string.unicode_at(0) - 65
	set_frame_coords(Vector2i(letter_num % 8, 2 + letter_num/8))
