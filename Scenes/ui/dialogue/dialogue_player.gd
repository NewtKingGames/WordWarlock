class_name DialoguePlayer
extends Node2D
var current_casting_text_parent_index: int = 0
@onready var casting_texts: Node2D = $CastingTexts
#@onready var casting_text_parent: CastingTextParent = $CastingTextParent
var casting_text_flow_over: Array[CastingTextParent] = []
@onready var typing_noises: TypingNoises = $TypingNoises
@onready var interact_area: Area2D = $InteractArea
@onready var keyboard_letter: KeyboardLetter = $KeyboardLetter


@export_multiline var prompt_array: Array[String] = []
@export var letter_delay_max: float = 0.08
@export var letter_delay_min: float = 0.03
var starting_prompt_index: int = 0
var current_prompt_index: int = 0
var is_playing_prompt: bool = false
var is_player_near: bool = false

func _ready() -> void:
	keyboard_letter.hide()
	#play_prompt(0)
	interact_area.body_entered.connect(_on_player_entered)
	interact_area.body_exited.connect(_on_player_exited)


func _process(delta: float) -> void:
	if is_player_near:
		# Display the interact button
		if Input.is_action_just_pressed("interact") and not is_playing_prompt and not Globals.is_player_casting:
			keyboard_letter.key_pressed()
			if current_prompt_index == prompt_array.size():
				reset_prompt()
			else:
				play_prompt(current_prompt_index)
				current_prompt_index+=1


func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		keyboard_letter.show()
		is_player_near = true

func _on_player_exited(body: Node2D) -> void:
	if body is Player:
		keyboard_letter.hide()
		is_player_near = false

func reset_prompt() -> void:
	keyboard_letter.hide()
	current_prompt_index = 0
	#casting_text_parent.clear_letters()
	clear_prompt()

func play_prompt(index: int) -> void:
	#casting_text_parent.clear_letters()
	clear_prompt()
	current_casting_text_parent_index = 0
	is_playing_prompt = true
	var prompt: String = prompt_array[index] as String
	if not prompt:
		return
	for character in prompt:
		if character == "\n":
			current_casting_text_parent_index += 1
		casting_texts.get_child(current_casting_text_parent_index).add_letter(character)
		typing_noises.play_typing_noise()
		await get_tree().create_timer(randf_range(letter_delay_min, letter_delay_max)).timeout
	is_playing_prompt = false
	

func clear_prompt() -> void:
	for casting_text_parent in casting_texts.get_children():
		casting_text_parent.clear_letters()
