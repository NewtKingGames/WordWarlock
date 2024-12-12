class_name CastingFlickerLight
extends PointLight2D
# Class to give flashy effects while the player is typing 

var drain_light: bool = true

func _ready() -> void:
	energy = 0
	Events.current_string_typed.connect(_on_current_string_typed)
	Events.current_string_matches.connect(_on_current_string_matches)
	Events.player_exited_casting_state.connect(_on_player_exited_casting_state)
	SpellSelector.player_equipped_spell_resource.connect(_on_player_equipped_spell)
	_on_player_equipped_spell(SpellSelector.equipped_spell_resource)


func _process(delta: float) -> void:
	if drain_light:
		energy = clampf(energy - (0.5 * delta / Engine.time_scale), 0, 20)
		print("subtracted:")
		print(0.1 * delta)
	print("energy:")
	print(energy)

func _on_current_string_typed(string: String) -> void:
	flicker_light()

func _on_current_string_matches(string: String) -> void:
	flash_light()

func _on_player_exited_casting_state() -> void:
	drain_light = true
	turn_off_light()

func flicker_light() -> void:
	energy += 0.1

func flash_light() -> void:
	drain_light = false
	energy = 1

func turn_off_light() -> void:
	energy = 0

func _on_player_equipped_spell(spell: SpellResource) -> void:
	color = spell.secondary_color
