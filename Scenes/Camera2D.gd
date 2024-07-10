extends Camera2D

@export var random_strength: float = 50
@export var shake_fade: float = 10

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	Globals.connect("player_damage", apply_shake)
	player.connect("casting_state_entered", on_casting_state_entered)
	
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade*delta)
	offset = random_offset()
	
func apply_shake():
	shake_strength = random_strength

func on_casting_state_entered():
	print("player started typing")
	
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
