extends Node2D

signal player_equipped_spell(spell_name: String)
# TODO - you could think about a fun way of letting the player auto cycle through their spells?
# TODO - this is really gross right now because spells are a node and not a resource....
@export var available_spells: Array[String] = []

# TODO - need to make sure this get's initialized correctly
@export var equipped_spell: String
var equipped_index: int = 0

@onready var canvas_layer: CanvasLayer = $CanvasLayer


@onready var equip_spell_icon_slot_one: EquipSpellIcon = $CanvasLayer/EquipSpellIcon_SlotOne
@onready var keyboard_letter_one: KeyboardLetter = $CanvasLayer/EquipSpellIcon_SlotOne/KeyboardLetter

@onready var equip_spell_icon_slot_two: EquipSpellIcon = $CanvasLayer/EquipSpellIcon_SlotTwo
@onready var keyboard_letter_two: KeyboardLetter = $CanvasLayer/EquipSpellIcon_SlotTwo/KeyboardLetterTwo

@onready var equip_spell_icon_slot_three: EquipSpellIcon = $CanvasLayer/EquipSpellIcon_SlotThree
@onready var keyboard_letter_three: KeyboardLetter = $CanvasLayer/EquipSpellIcon_SlotThree/KeyboardLetterThree

@onready var equip_spell_icon_slot_four: EquipSpellIcon = $CanvasLayer/EquipSpellIcon_SlotFour
@onready var keyboard_letter_four: KeyboardLetter = $CanvasLayer/EquipSpellIcon_SlotFour/KeyboardLetterFour

var spell_icon_array: Array = []
var letter_icon_array: Array[KeyboardLetter] = []

func _ready() -> void:
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
	equipped_index = index
	equipped_spell = available_spells[index]
	do_equip_effects(index)
	# TODO - need to make these dynamic!!
	player_equipped_spell.emit(equipped_spell)

func do_equip_effects(index: int) -> void:
	letter_icon_array[index].key_pressed()
	
func _on_player_entered_toggle_area(is_active: bool) -> void:
	#print("setting is active to")
	#print(is_active)
	canvas_layer.visible = is_active
