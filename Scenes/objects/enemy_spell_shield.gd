extends Node2D
class_name EnemySpellShield

var spell_break: String
var enemy_parent: EnemyClass
@onready var spell_break_text: Label = $SpellBreakText
@onready var break_noise: AudioStreamPlayer2D = $BreakNoise
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready():
	# Choose random spell to be the spell break
	spell_break = GlobalSpells.enemy_spell_shield_words[randi_range(0, GlobalSpells.enemy_spell_shield_words.size()-1)]
	spell_break_text.text = spell_break.to_upper()
	# Make the parent enemy object invulnerable
	if is_instance_of(get_parent(), EnemyClass):
		enemy_parent = get_parent()
		enemy_parent.can_take_damage = false
	else:
		print("shield attached to something that's not the player INVESTIGATE")
	# Subscribe to player spell_cast signal
	get_tree().get_first_node_in_group("player").connect("spell_string_cast", on_player_spell_cast_string)


func on_player_spell_cast_string(string: String):
	if visible_on_screen_notifier_2d.is_on_screen() && spell_break.to_upper() == string.to_upper():
		enemy_parent.can_take_damage = true
		# TODO add some more audio and visual effects!
		break_noise.play()
		$AnimationPlayer.play("break")
		#visible = false
		$Sprite2D.visible = false
		$SpellBreakText.visible = false
		await get_tree().create_timer(1).timeout
		queue_free()
