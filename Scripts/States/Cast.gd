extends State
# Catch all signal for entering and exiting the cast state. If exiting it will include the String if the player attempted to cast, and if the player was successful it will include the spell scene
# TODO how to handle counter spells?
# TODO Next step is to creat an actual response object from the Cast state to give me more flexibility, instead of passing 3 variables around especially because you can't type hint the signals correctly
signal cast_spell_state_changed(is_state_active: bool, string_typed, spell_scene)
# TODO - you might need to change this to support the "escape" key situation
signal player_attempted_spell()

@onready var player: Player = $"../.."
@onready var character_animated_sprite_2d: AnimatedSprite2D = $"../../CharacterAnimatedSprite2D"
@onready var slow_mo_sound_enter: AudioStreamPlayer2D = $"../../Sounds/SlowMoSoundEnter"
@onready var slow_mo_sound_exit: AudioStreamPlayer2D = $"../../Sounds/SlowMoSoundExit"
@onready var casting_text_parent: = $"../../CastingTextParent" # NEW VISUAL INDICATOR FOR SPELLS

var keyboard: Keyboard

var rng = RandomNumberGenerator.new()

# TODO Change the audio on these to be more magical rather than a type writer
var typing_noises: Array
var regex: RegEx = RegEx.new()
var cast_string: String = "" :
	set(value):
		cast_string = value
		Events.current_string_typed.emit(cast_string)

func _ready():
	regex.compile("[a-zA-Z]")
	typing_noises = $"../../Sounds/TypingSounds".get_children()
	keyboard = get_tree().get_first_node_in_group("keyboard")
	Events.clear_typed_string.connect(_on_clear_typed_string)

func Enter():
	# new signal
	cast_spell_state_changed.emit(true, null, null)
	# new global signal
	Events.player_entered_casting_state.emit()
	character_animated_sprite_2d.play("cast_spell")
	_clear_entered_text()
	casting_text_parent.clear_letters()
	casting_text_parent.visible = true

func Exit():
	casting_text_parent.visible = false
	var casted_spell = String(cast_string)
	var spell_scene: PackedScene = GlobalSpells.get_spell_scene_for_string(casted_spell)
	# old signal
	cast_spell_state_changed.emit(false, casted_spell, spell_scene)
	# new global signal
	Events.player_exited_casting_state.emit()
	
func Update(_delta: float):
	# Player Casting Spell
	if Input.is_action_just_pressed("enter"):
		if cast_string == "":
			Transitioned.emit(self, "idle")
			return
		# TODO - if you ever want to reintroduce old style you'll need this back!!!
		#Transitioned.emit(self, "idle")
		Events.player_entered_spell_string.emit(cast_string)
		_clear_entered_text()
	# Player Cancelling Spell
	elif Input.is_action_just_pressed("exit"):
		_clear_entered_text()
		Transitioned.emit(self, "idle")

func Handle_Input(_event: InputEvent):
	var event_string: String = _event.as_text()
	if _event.is_pressed() and not _event.is_echo() and not _event.is_action_pressed("exit"):
		var keyboard_letter: String = keyboard.key_pressed(event_string)
		if regex.search(event_string) and event_string.length() == 1:
			if keyboard_letter != "":
				cast_string += event_string
				casting_text_parent.add_letter(event_string)
			else:
				# Play error noise
				$"../../Sounds/TypingSounds/ErrorTypingNoise".play()
		elif _event.is_action_pressed("space") and cast_string.length() > 0:
			cast_string += " "
			casting_text_parent.add_letter(" ")
		elif _event.is_action_pressed("backspace") and cast_string.length() > 0:
			cast_string = cast_string.left(cast_string.length() - 1)
			casting_text_parent.delete_letter()
		if GlobalSpells.is_string_known_spell(cast_string):
			var spell = GlobalSpells.get_known_spell_for_string(cast_string)
			casting_text_parent.set_modulate(spell.get_spell_color())
		else:
			casting_text_parent.set_modulate(Color.WHITE)
		

func _clear_entered_text() -> void:
	cast_string = ""
	casting_text_parent.clear_letters()

func _on_clear_typed_string() -> void:
	_clear_entered_text()
