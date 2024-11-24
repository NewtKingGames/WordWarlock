extends CPUParticles2D


func _ready() -> void:
	# Since SpellSelector is globally loaded we don't get the first spell equip event
	# Solve this by manually calling the equip function with the current equipped spell
	_on_spell_equipped(SpellSelector.equipped_spell_resource)
	SpellSelector.player_equipped_spell_resource.connect(_on_spell_equipped)

func _process(delta: float) -> void:
	speed_scale = 1 / Engine.time_scale

func _on_spell_equipped(spell: SpellResource) -> void:
	# Leave the first black partially transparent point the same, set the last color to the primary color?
	print(spell.primary_color)
	color_ramp.set_color(1, spell.primary_color)
# The original purple color I set for this node was Color(0.514, 0.404, 1) 
