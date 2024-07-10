extends Area2D
class_name Spell

@export var spell_name: String
@export var spell_emit_sound: AudioStreamPlayer2D

func _ready():
	spell_emit_sound.play()


static func get_spell_color():
	return Color.BLUE_VIOLET
