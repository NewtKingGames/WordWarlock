extends Area2D
class_name Spell

@export var spell_name: String
@export var spell_emit_sound: AudioStreamPlayer2D

func _ready():
	print("base spell class ready")
	spell_emit_sound.play()

