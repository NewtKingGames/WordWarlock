extends EffectSpell
class_name Haste

func _ready():
	super._ready()
	Globals.player_walk_speed = Globals.player_base_walk_speed * 1.5

# Overrides
static func get_spell_color():
	return Color.YELLOW

func _on_spell_duration_timeout():
	# Maybe play sound?
	Globals.player_walk_speed = Globals.player_base_walk_speed
	queue_free()
