extends Node


# Player-related signals
signal player_entered_casting_state
signal player_exited_casting_state
signal player_entered_spell_string(string: String) # Player pressed 'enter' with a current spell 

# Typing-related signals
signal current_string_typed(string: String) # The current string that the player has just typed
signal current_string_matches(string: String)
signal clear_typed_string # Signal to clear the currently typed string

# Spell-related signals
signal spell_casted(spell: Spell)

# Area-related signals
signal spell_stack_toggle_area_entered(toggle_value: bool)

# Curse-related signals
signal start_curse(curse_type: Curse.CURSE_TYPE)
signal player_blinded(blinded: bool)

# Camera-related signals
signal shake_screen(strength: float)

# Enemy-related signals
signal bat_spit(speed: float, direction: Vector2, position: Vector2)
