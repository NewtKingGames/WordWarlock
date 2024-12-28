class_name SpellStackParent
extends Node2D

@export var is_enabled: bool = true
@onready var complete_stack_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

const SPELL_STACK_SCENE: PackedScene = preload("res://Scenes/ui/spell_stack/spell_stack.tscn")
# See if you can get away with not using this and instead just use get_children/get_child_count
#var spell_stack_children: Array[SpellStack] = []

func _ready() -> void:
	modulate = Color(1,1,1,0)
	for child in get_children():
		if child is SpellStack:
			child.queue_free()
	Events.current_string_typed.connect(_on_player_typed_string)
	# BY subscribing to both the player can either hit space or hit enter
	Events.player_exited_casting_state.connect(_on_player_exited_casting_state)
	Events.player_entered_spell_string.connect(_on_playered_entered_spell_string)
	# The spell stack parent can be responsible for initializing a spell stack when the player equips a spell?
	# Or alternatively when they press enter with one selected? Coding both to find which is more fun
	SpellSelector.player_equipped_spell.connect(_on_player_equipped_spell)
	Events.player_entered_casting_state.connect(_on_player_entered_casting_state)
	# Events related to status
	Events.spell_stack_toggle_area_entered.connect(_on_player_entered_toggle_area)

func _on_player_entered_toggle_area(toggle_value: bool) -> void:
	is_enabled = toggle_value
	clear_stacks()


func _on_player_equipped_spell(spell_name: String) -> void:
	var active_spell_stack = get_active_spell_stack()
	if active_spell_stack and active_spell_stack.spell.spell_name == spell_name:
			return
	clear_stacks()
	add_spell_stack(GlobalSpells.get_spell_scene_for_string(SpellSelector.equipped_spell).instantiate())

func _on_player_entered_casting_state() -> void:
	if not is_enabled:
		return
	VisualUtils.fade_in_node(self, 0.1)
	if not get_active_spell_stack():
		add_spell_stack(GlobalSpells.get_spell_scene_for_string(SpellSelector.equipped_spell).instantiate())

func _on_player_exited_casting_state() -> void:
	VisualUtils.fade_out_node(self, 0.05)
	# TODO - if you want to delete this?
	#clear_stacks()
	
func clear_stacks() -> void:
	for child in get_children():
		if child is SpellStack:
			child.queue_free()

func add_spell_stack(spell: Spell) -> void:
	var spell_stack_child = SPELL_STACK_SCENE.instantiate()
	spell_stack_child.init(spell)
	spell_stack_child.spell_stack_completed.connect(_on_child_spell_stack_completed)
	add_child(spell_stack_child)


func remove_spell_stack(spell_stack: SpellStack) -> void:
	spell_stack.queue_free()
	
	
func _on_child_spell_stack_completed(spell_stack: SpellStack) -> void:
	#complete_stack_sound.play()
	Events.spell_casted.emit(spell_stack.spell)
	remove_spell_stack(spell_stack)

func _on_player_typed_string(string: String) -> void:
	var spell_stack: SpellStack = get_active_spell_stack()
	if not spell_stack or spell_stack.spell_stack_word_children.size() == 0:
		return
	# If player has currently entered the spell string
	if string.to_upper() == spell_stack.spell_stack_word_children[0].word.to_upper():
		Events.current_string_matches.emit(string)
	# If player entered the spell string and then hit "space"
	if string.to_upper() == spell_stack.spell_stack_word_children[0].word.to_upper() + " ":
		Events.clear_typed_string.emit()
		spell_stack.pop_spell()
	#spell_stack.on_player_typed_string(string)

func _on_playered_entered_spell_string(string: String) -> void:
	var spell_stack: SpellStack = get_active_spell_stack()
	if not spell_stack:
		return
	spell_stack.on_player_typed_string(string)

func get_active_spell_stack() -> SpellStack:
	for child in get_children():
		if child is SpellStack:
			return child
	return null
