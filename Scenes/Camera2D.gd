extends Camera2D

@export var random_strength: float = 2.5
@export var shake_fade: float = 10

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("player_damage", apply_shake)
	
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade*delta)
	offset = random_offset()
	
func apply_shake():
	shake_strength = random_strength
	
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
