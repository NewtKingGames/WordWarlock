extends State
class_name Cast

signal CastSpell(spell_string: String)
signal casting_state_entered
signal casting_state_exited
signal casting_key_pressed(letter_string: String)


@onready var character_animated_sprite_2d: AnimatedSprite2D = $"../../CharacterAnimatedSprite2D"
@onready var casting_text_label = $"../../CastingText"
@onready var slow_mo_sound_enter = $"../../Sounds/SlowMoSoundEnter"
@onready var slow_mo_sound_exit = $"../../Sounds/SlowMoSoundExit"

var rng = RandomNumberGenerator.new()

# TODO Change the audio on these to be more magical rather than a type writer
var typing_noises: Array
var regex: RegEx = RegEx.new()
var cast_string: String = ""

func _ready():
	# this currently doesn't allow space bar
	regex.compile("[a-zA-Z]")
	typing_noises = $"../../Sounds/TypingSounds".get_children()

func Enter():
	character_animated_sprite_2d.play("cast_spell")
	cast_string = ""
	casting_text_label.text = cast_string
	casting_text_label.visible = true
	# Start bullet time 
	Engine.time_scale = 0.5
	slow_mo_sound_enter.play()
	slow_mo_sound_exit.stop()
	casting_state_entered.emit()

func Exit():
	casting_text_label.visible = false
	# Undo bullet time
	Engine.time_scale = 1
	slow_mo_sound_enter.stop()
	slow_mo_sound_exit.play()
	casting_state_exited.emit()
	
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

# This timer solution is probably a little hacky, but we'll use it for now
func Handle_Input(_event: InputEvent):
	var event_string: String = _event.as_text()
	if regex.search(event_string) and event_string.length() == 1 and not _event.is_echo() and _event.is_pressed():
		cast_string += event_string
		casting_text_label.text = cast_string
		typing_noises[rng.randi_range(0,2)].play()
		casting_key_pressed.emit(event_string.to_upper())
	elif _event.is_action_pressed("space") and cast_string.length() > 0:
		cast_string += " "
		casting_text_label.text = cast_string
		typing_noises[rng.randi_range(0,2)].play()
	elif _event.is_action_pressed("backspace") and cast_string.length() > 0:
		cast_string = cast_string.left(cast_string.length() - 1)
		casting_text_label.text = cast_string
		typing_noises[rng.randi_range(0,2)].play()
		
		
