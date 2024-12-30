class_name CurseNotifyVisuals
extends Node2D

var curse: Curse
var player: Player
@onready var casting_text_parent: CastingTextParent = $CastingTextParent
@onready var curse_text_background: Sprite2D = $CurseTextBackground
@onready var curse_sound: AudioStreamPlayer2D = $CurseSound


func _ready() -> void:
	curse_text_background.modulate = Color(1,1,1, 0)
	curse = FrozenKeyCurse.new()
	_show_curse_name()
	get_tree().create_timer(5, true, false, true).timeout.connect(_hide_curse_name)

func _process(delta: float) -> void:
	if player:
		global_position = player.global_position

func _show_curse_name() -> void:
	get_tree().create_timer(0.25, true, false, true).timeout.connect(curse_sound.play)
	var background_tween: Tween = create_tween()
	background_tween.tween_property(curse_text_background, "modulate", Color(1,1,1,0.7), 0.2)
	await background_tween.finished
	var color_tween: Tween = create_tween().set_loops()
	casting_text_parent.modulate = curse.primary_color
	color_tween.tween_property(casting_text_parent, "modulate", curse.secondary_color, 0.5)
	color_tween.tween_property(casting_text_parent, "modulate", curse.primary_color, 0.5)
	for letter in curse.name:
		casting_text_parent.add_letter(letter)
		await get_tree().create_timer(0.04, true, false, true).timeout

func _hide_curse_name() -> void:
	VisualUtils.fade_out_node(self, 1.0)
	get_tree().create_timer(3, true, false, true).timeout.connect(queue_free)
