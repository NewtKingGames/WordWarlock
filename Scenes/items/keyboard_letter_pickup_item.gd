extends Area2D
class_name KeyboardLetterPickupItem

@onready var letter_sprite = $Sprites/LetterSprite
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $PickupArea

var keyboard_letter: KeyboardLetter
var is_active: bool = true
var player: Player
var navigate_to_player: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	letter_sprite.set_letter_string(keyboard_letter.letter_string) # Uncomment when done testing


func _on_body_entered(body):
	if not is_active:
		return
	if is_instance_of(body, Player):
		is_active = false
		var opposite_direction_from_player: Vector2  = (global_position - body.global_position) / 2.5
		var location_away_from_player: Vector2 = opposite_direction_from_player + global_position
		var tween: Tween = create_tween()
		await tween.tween_property(self, "position", location_away_from_player, .2).finished
		navigate_to_player = true
		# Todo it would be cool to have some fun lighting/sounds here to indicate the player got an item back


func _process(delta):
	if navigate_to_player:
		var vector_to_player = global_position.direction_to(player.global_position)
		position = position + vector_to_player * 1000 * delta
		# Once the item get's close enough start the animation
		if global_position.distance_to(player.global_position) < 300:
			animation_player.play("pickup")
			keyboard_letter.letter_active = true # Uncomment when done testing
