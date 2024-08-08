extends Area2D
class_name KeyboardLetterPickupItem

@onready var letter_sprite = $Sprites/LetterSprite
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $PickupArea

var keyboard_letter: KeyboardLetter
var is_active: bool = true

# TODO this class neeeds all kinds of retweaking

func _ready():
	#letter_sprite.set_letter_string(keyboard_letter.letter_string)
	letter_sprite.set_letter_string("A")


func _on_body_entered(body):
	if not is_active:
		return
	if is_instance_of(body, Player):
		is_active = false
		var opposite_direction_from_player: Vector2  = (global_position - body.global_position)
		var location_away_from_player: Vector2 = opposite_direction_from_player + global_position
		var tween: Tween = create_tween()
		tween.tween_property(self, "position", location_away_from_player, .2)
		animation_player.play("pickup")
		tween.tween_property(self, "position", body.global_position, .1)
		#keyboard_letter.letter_active = true


#func _on_animation_player_animation_finished(anim_name: String):
	#if anim_name == "pickup":
		#print("done picking up")
		#
		#queue_free()
