extends State
class_name Cast

signal CastSpell(spell_string: String)
signal cast_spell_changed(is_state_active: bool)

@onready var player = $"../.."
# TODO - this might be unnceccessary coupling
@onready var spell_caster: SpellCaster = $"../../SpellCaster"
@onready var character_animated_sprite_2d: AnimatedSprite2D = $"../../CharacterAnimatedSprite2D"
@onready var casting_text_label: Label = $"../../CastingText"
@onready var slow_mo_sound_enter: AudioStreamPlayer2D = $"../../Sounds/SlowMoSoundEnter"
@onready var slow_mo_sound_exit: AudioStreamPlayer2D = $"../../Sounds/SlowMoSoundExit"

var keyboard: Keyboard

var rng = RandomNumberGenerator.new()

# TODO Change the audio on these to be more magical rather than a type writer
var typing_noises: Array
var regex: RegEx = RegEx.new()
var cast_string: String = ""

func _ready():
	regex.compile("[a-zA-Z]")
	typing_noises = $"../../Sounds/TypingSounds".get_children()
	keyboard = get_tree().get_first_node_in_group("keyboard")

func Enter():
	cast_spell_changed.emit(true)
	character_animated_sprite_2d.play("cast_spell")
	cast_string = ""
	casting_text_label.text = cast_string
	casting_text_label.visible = true
	casting_text_label.set_modulate(Color.WHITE)
	player.casting_state_entered.emit()

func Exit():
	casting_text_label.visible = false
	cast_spell_changed.emit(false)
	player.casting_state_exited.emit()
	
func Update(_delta: float):
	# Player Casting Spell
	if Input.is_action_just_pressed("enter"):
		# TODO - this copying of cast_string might be unneccessary
		var casted_spell = String(cast_string)
		CastSpell.emit(casted_spell)
		Transitioned.emit(self, "idle")
	# Player Cancelling Spell
	elif Input.is_key_pressed(KEY_ESCAPE):
		Transitioned.emit(self, "idle")

func Handle_Input(_event: InputEvent):
	var event_string: String = _event.as_text()
	if _event.is_pressed() and not _event.is_echo() and not _event.is_action_pressed("enter"):
		if regex.search(event_string) and event_string.length() == 1:
			var keyboard_letter: String = keyboard.key_pressed(event_string)
			if keyboard_letter != "":
				cast_string += event_string
				casting_text_label.text = cast_string
				# Randomize typing clip and pitch
				var typing_noise_index: int = rng.randi_range(0,2)
				typing_noises[typing_noise_index].pitch_scale = rng.randf_range(.93, 1.08)
				typing_noises[typing_noise_index].play()
			else:
				typing_noises[3].play()
			# TODO decide to keep or get rid of this signal
			#player.casting_key_pressed.emit(event_string.to_upper())
		elif _event.is_action_pressed("space") and cast_string.length() > 0:
			cast_string += " "
			casting_text_label.text = cast_string
			typing_noises[rng.randi_range(0,2)].play()
		elif _event.is_action_pressed("backspace") and cast_string.length() > 0:
			cast_string = cast_string.left(cast_string.length() - 1)
			casting_text_label.text = cast_string
			typing_noises[rng.randi_range(0,2)].play()
		if spell_caster.is_string_known_spell(cast_string):
			var spell = spell_caster.get_known_spell_for_string(cast_string)
			casting_text_label.set_modulate(spell.get_spell_color())
		else:
			casting_text_label.set_modulate(Color.WHITE)
		
