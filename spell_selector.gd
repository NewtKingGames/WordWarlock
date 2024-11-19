extends Node2D

signal player_equipped_spell(spell_name: String)
# TODO - you could think about a fun way of letting the player auto cycle through their spells?
# TODO - this is really gross right now because spells are a node and not a resource....
@export var available_spells: Array[String] = []

# TODO - need to make sure this get's initialized correctly
@export var equipped_spell: String
@export var is_active: bool = true
var equipped_index: int = 0


@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var typing_noises: TypingNoises = $TypingNoises

# Spell one
@onready var equip_spell_icon_slot_one: EquipSpellIcon = $CanvasLayer/EquipSpellIcon_SlotOne
@onready var keyboard_letter_one: KeyboardLetter = $CanvasLayer/EquipSpellIcon_SlotOne/KeyboardLetter

# Spell two
@onready var equip_spell_icon_slot_two: EquipSpellIcon = $CanvasLayer/EquipSpellIcon_SlotTwo
@onready var keyboard_letter_two: KeyboardLetter = $CanvasLayer/EquipSpellIcon_SlotTwo/KeyboardLetterTwo

# Spell three
@onready var equip_spell_icon_slot_three: EquipSpellIcon = $CanvasLayer/EquipSpellIcon_SlotThree
@onready var keyboard_letter_three: KeyboardLetter = $CanvasLayer/EquipSpellIcon_SlotThree/KeyboardLetterThree

# Spell four
@onready var equip_spell_icon_slot_four: EquipSpellIcon = $CanvasLayer/EquipSpellIcon_SlotFour
@onready var keyboard_letter_four: KeyboardLetter = $CanvasLayer/EquipSpellIcon_SlotFour/KeyboardLetterFour

var spell_icon_array: Array = []
var letter_icon_array: Array[KeyboardLetter] = []

func _ready() -> void:
	canvas_layer.visible = is_active
	spell_icon_array.append(equip_spell_icon_slot_one)
	spell_icon_array.append(equip_spell_icon_slot_two)
	spell_icon_array.append(equip_spell_icon_slot_three)
	spell_icon_array.append(equip_spell_icon_slot_four)
	letter_icon_array.append(keyboard_letter_one)
	letter_icon_array.append(keyboard_letter_two)
	letter_icon_array.append(keyboard_letter_three)
	letter_icon_array.append(keyboard_letter_four)
	
	Events.spell_stack_toggle_area_entered.connect(_on_player_entered_toggle_area)

func _process(delta: float) -> void:
	if not is_active:
		return
	# Only allow changing spells if the player is not casting
	if Globals.is_player_casting:
		return
	if Input.is_action_just_pressed("equip_spell_one"):
		equip_spell(0)
	if Input.is_action_just_pressed("equip_spell_two"):
		equip_spell(1)
	if Input.is_action_just_pressed("equip_spell_three"):
		equip_spell(2)
	if Input.is_action_just_pressed("equip_spell_four"):
		equip_spell(3)


func equip_spell(index: int) -> void:
	if equipped_index == index:
		# TODO - could play noise here to indicate already equipped
		return
	do_equip_effects(equipped_index, index)
	equipped_index = index
	equipped_spell = available_spells[index]
	# TODO - need to make these dynamic!!
	player_equipped_spell.emit(equipped_spell)

func do_equip_effects(old_index: int, new_index: int) -> void:
	letter_icon_array[new_index].key_pressed_stick_key()
	letter_icon_array[old_index].unstick_key()
	typing_noises.play_typing_noise_global()
	
func _on_player_entered_toggle_area(value: bool) -> void:
	self.is_active = value
	canvas_layer.visible = value
