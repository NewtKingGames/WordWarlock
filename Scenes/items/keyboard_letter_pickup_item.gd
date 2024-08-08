extends Area2D
class_name KeyboardLetterPickupItem

@onready var letter_sprite: LetterSprite = $LetterSprite
@onready var animation_player = $AnimationPlayer

var keyboard_letter: KeyboardLetter

func _ready():
	print("Item spawned")
	print(keyboard_letter)
	letter_sprite.set_letter_string(keyboard_letter.letter_string)



func _on_body_entered(body):
	if is_instance_of(body, Player):
		animation_player.play("pickup")


func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "pickup":
		print("done picking up")
		keyboard_letter.letter_active = true
		queue_free()
