class_name SpellResource # TODO - someday when you migrate to Spells as resources you could remove the suffix "Resource"
extends Resource

@export var spell_name: String
@export var associated_words: Array[String]
@export var primary_color: Color
@export var secondary_color: Color
@export var emit_sound: AudioStream

