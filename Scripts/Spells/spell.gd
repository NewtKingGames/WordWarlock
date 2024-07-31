extends Area2D
class_name Spell

@export var spell_name: String
@export var spell_emit_sound: AudioStreamPlayer2D

func _ready():
	# Randomize pitch of spell
	spell_emit_sound.pitch_scale = randf_range(0.9, 1.1)
	spell_emit_sound.play()


static func get_spell_color():
	return Color.BLUE_VIOLET
