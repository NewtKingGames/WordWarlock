extends Node


# Player-related signals
signal player_entered_casting_state
signal player_exited_casting_state
signal player_entered_spell_string(string: String)

# Typing-related signals
signal current_string_typed(string: String)
signal string_entered(string: String)


# Spell-related signals
signal spell_casted(spell: Spell)
