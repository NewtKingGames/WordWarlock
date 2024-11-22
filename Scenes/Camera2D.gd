extends Camera2D

@export var random_strength: float = 80
@export var shake_fade: float = 8
@export var typing_zoom_rate: float = 5

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0
var player: Player
var camera_target_zoom: Vector2 = zoom

func _ready():
	player = get_tree().get_first_node_in_group("player")
	Globals.connect("player_damage", apply_shake)
	player.connect("slowdown_effect_entered", on_slowdown_effect_entered)
	player.connect("slowdown_effect_exited", on_slowdown_effect_exited)
	#Events.current_string_typed.connect(apply_shake_small)
	
func _process(delta):
	# Shake camera when player is damaged
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade*delta)
	# Zoom camera in when player is spelling
	if zoom != camera_target_zoom:
		# TODO - decide if you want to continue to use tweens here and if so delete the unneccessary code
		var zoom_tween: Tween = create_tween()
		zoom_tween.tween_property(self, "zoom", camera_target_zoom, 0.5)
		#zoom.x = lerpf(zoom.x, camera_target_zoom.x, typing_zoom_rate*delta)
		#zoom.y = lerpf(zoom.y, camera_target_zoom.y, typing_zoom_rate*delta)
	offset = random_offset()
	
func apply_shake():
	shake_strength = random_strength

func apply_shake_small(string: String):
	shake_strength = 0.6

func on_slowdown_effect_entered():
	camera_target_zoom = Vector2(2, 2)
	
func on_slowdown_effect_exited():
	camera_target_zoom = Vector2(1.4, 1.4)
	
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
