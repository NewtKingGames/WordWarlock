class_name SpellStackParent
extends Node2D

const SPELL_STACK_SCENE: PackedScene = preload("res://Scenes/ui/spell_stack/spell_stack.tscn")
# TODO - delete
const FIREBALL = preload("res://Scenes/projectiles/fireball.tscn")
# See if you can get away with not using this and instead just use get_children/get_child_count
#var spell_stack_children: Array[SpellStack] = []

func _ready() -> void:
	# Todo subscribe to relevant signals
	Events.current_string_typed.connect(_on_player_typed_string)
	# TODO - delete
	var fireball: Fireball = FIREBALL.instantiate()
	add_spell_stack(fireball)


func add_spell_stack(spell: Spell) -> void:
	var spell_stack_child = SPELL_STACK_SCENE.instantiate()
	spell_stack_child.init(spell)
	spell_stack_child.spell_stack_completed.connect(_on_child_spell_stack_completed)
	add_child(spell_stack_child)


func remove_spell_stack(spell_stack: SpellStack) -> void:
	print("removing spell stack")
	spell_stack.queue_free()
	
	
func _on_child_spell_stack_completed(spell_stack: SpellStack) -> void:
	remove_spell_stack(spell_stack)
	# TODO - emit the spell effect

func _on_player_typed_string(string: String) -> void:
	var spell_stack: SpellStack = get_active_spell_stack()
	if not spell_stack:
		return
	spell_stack.on_player_typed_string(string)

func get_active_spell_stack() -> SpellStack:
	if get_child_count() > 0:
		return get_child(0)
	return null
