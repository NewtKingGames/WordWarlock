extends EffectSpell
class_name Haste
@onready var end_effect_noise = $EndEffectNoise

# See if you can add this shader effect to this scene https://godotshaders.com/shader/2d-shadows-shader/ 


func _ready():
	super._ready()
	Globals.player_walk_speed = Globals.player_base_walk_speed * 1.5

# Overrides
static func get_spell_color():
	return Color.YELLOW

func _on_spell_duration_timeout():
	end_effect_noise.play()
	Globals.player_walk_speed = Globals.player_base_walk_speed
	$PointLight2D.visible = false
	await get_tree().create_timer(.55).timeout
	queue_free()
