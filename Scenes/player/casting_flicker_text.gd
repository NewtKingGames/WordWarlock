class_name CastingFlickerLight
extends PointLight2D
# Class to give flashy effects while the player is typing 

# TODO - should have it only grow in size when the word is getting closer to the 
var drain_light: bool = true


var outer_light_range: float = 0.1
var inner_light_range: float = 0.06

var target_hum_pitch: float = 1.0
var target_hum_pitch_cap_without_match: float = 2.5
var target_hum_pitch_when_matching: float = 3.0

var strength: float = 0.0
@onready var hum_audio: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"

func _ready() -> void:
	energy = 0
	Events.current_string_typed.connect(_on_current_string_typed)
	Events.current_string_matches.connect(_on_current_string_matches)
	Events.player_exited_casting_state.connect(_on_player_exited_casting_state)
	Events.player_entered_casting_state.connect(_on_player_entered_casting_state)
	SpellSelector.player_equipped_spell_resource.connect(_on_player_equipped_spell)
	_on_player_equipped_spell(SpellSelector.equipped_spell_resource)


func _process(delta: float) -> void:
	if drain_light:
		# Calculate random drain
		var random_drain = delta * randf_range(0.2, 0.7) / Engine.time_scale
		strength = strength - random_drain 
		energy = clampf(energy - random_drain, 0, 20)
		texture_scale = clampf(texture_scale - random_drain, 0, 20)
		texture_scale = lerpf(inner_light_range, outer_light_range, 0.1)
	hum_audio.pitch_scale = lerpf(hum_audio.pitch_scale, target_hum_pitch, 100*delta)
	
	#print("energy:")
	#print(energy)

func _on_current_string_typed(string: String) -> void:
	#target_hum_pitch = clampf(target_hum_pitch + 0.25, 1, target_hum_pitch_cap_without_match) 
	flicker_light()

func _on_current_string_matches(string: String) -> void:
	target_hum_pitch = target_hum_pitch_when_matching + (target_hum_pitch * randf_range(-.1, 0.1))
	flash_light()

func _on_player_exited_casting_state() -> void:
	drain_light = true
	turn_off_light()
	get_tree().create_timer(0.15).timeout.connect(
		func(): 
			target_hum_pitch = 1
			hum_audio.stop()
	)

func _on_player_entered_casting_state() -> void:
	hum_audio.play()

func flicker_light() -> void:
	strength += 0.5
	energy += 0.1
	texture_scale += 0.01

func flash_light() -> void:
	drain_light = false
	energy = 0.75
	texture_scale = 0.5

func turn_off_light() -> void:
	energy = 0
	texture_scale = 0

func _on_player_equipped_spell(spell: SpellResource) -> void:
	color = spell.secondary_color
