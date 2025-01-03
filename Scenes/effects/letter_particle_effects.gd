extends CPUParticles2D

@onready var emitting_timer: Timer = $EmittingTimer

func _ready() -> void:
	# Since SpellSelector is globally loaded we don't get the first spell equip event
	# Solve this by manually calling the equip function with the current equipped spell
	_on_spell_equipped(SpellSelector.equipped_spell_resource)
	SpellSelector.player_equipped_spell_resource.connect(_on_spell_equipped)
	Events.spell_stack_toggle_area_entered.connect(_on_player_entered_toggle_area)
	Events.current_string_typed.connect(_on_player_typed_string)
	emitting_timer.timeout.connect(
		func(): 
			emitting = false
	)

func _process(delta: float) -> void:
	speed_scale = 1 / Engine.time_scale
	emitting_timer.wait_time = 1 * Engine.time_scale

func _on_spell_equipped(spell: SpellResource) -> void:
	var clear_primary: Color = Color(spell.primary_color)
	clear_primary.a = 0
	var clear_secondary: Color = Color(spell.secondary_color)
	clear_secondary.a = 0
	color_ramp.set_color(0, clear_primary)
	color_ramp.set_color(1, spell.primary_color)
	color_ramp.set_color(2, spell.secondary_color)
	color_ramp.set_color(3, clear_secondary)
# The original purple color I set for this node was Color(0.514, 0.404, 1) 

func _on_player_entered_toggle_area(value: bool) -> void:
	visible = value

func _on_player_typed_string(string: String) -> void:
	if visible:
		# Start to emit effects
		emitting = true
		emitting_timer.start()
		
