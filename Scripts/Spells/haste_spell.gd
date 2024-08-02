extends EffectSpell
class_name Haste
@onready var end_effect_noise = $EndEffectNoise

func _ready():
	super._ready()
	Globals.player_walk_speed = Globals.player_base_walk_speed * 1.5

# Overrides
static func get_spell_color():
	return Color.YELLOW

func _on_spell_duration_timeout():
	# Maybe play sound on slow down?
	Globals.player_walk_speed = Globals.player_base_walk_speed
	end_effect_noise.play()
	await get_tree().create_timer(.55).timeout
	queue_free()
