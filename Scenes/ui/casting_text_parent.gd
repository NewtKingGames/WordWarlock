class_name CastingTextParent extends Node2D

@export var is_attached_to_player: bool = false

var child_text_scene: PackedScene = preload("res://Scenes/ui/casting_text_child.tscn")
var letter_position_offset: float = 10
var current_string: String = ""


func _ready() -> void:
	if is_attached_to_player:
		Events.current_string_matches.connect(_on_current_string_matches)
		Events.current_string_typed.connect(_on_current_string_typed)

func add_letter(letter: String):
	current_string = current_string + letter
	var child_text_node: CastingTextChild = child_text_scene.instantiate()
	child_text_node.text = letter
	# This helps center the list of letters
	child_text_node.position = Vector2(letter_position_offset*(current_string.length()-1), 0)
	slide_all_previous_letters_left(child_text_node.position)
	add_child(child_text_node)

func slide_all_previous_letters_left(furthest_right_pos: Vector2):
	var index: int = 0
	for letter in get_children():
		if letter is CastingTextChild:
			# TODO see if you can get the tween solution working someday
			#var tween: Tween = create_tween().parallel()
			#tween.tween_property(letter, "position", Vector2(furthest_right_pos.x -(letter_position_offset * (current_string.length()-index)), letter.position.y), 0.05 * Engine.time_scale)
			#print(furthest_right_pos.x -(letter_position_offset * (current_string.length()-index)))
			letter.position.x = letter.position.x - letter_position_offset
			letter.other_letter_added_effect()
	
func slide_all_previous_letters_right(furthest_right_pos: Vector2):
	for letter in get_children():
		if letter is CastingTextChild:
			# TODO see if you can get the tween solution working someday
			letter.position.x = letter.position.x + letter_position_offset
			#var tween: Tween = create_tween().parallel()
			#tween.tween_property(letter, "position", Vector2(furthest_right_pos.x + (letter_position_offset * (current_string.length()-index)), letter.position.y), 0.05 * Engine.time_scale)
			#print(furthest_right_pos.x -(letter_position_offset * (current_string.length()-index)))
			letter.other_letter_removed_effect()

func delete_letter():
	if current_string.length() == 0:
		return
	current_string = current_string.left(current_string.length() - 1)
	var total_children: int = get_child_count()
	if total_children == 0:
		print("skipping delete no children")
		return
	slide_all_previous_letters_right(get_children()[total_children-1].position)
	get_children()[total_children-1].remove()

func clear_letters():
	# Directly call queue_free to delete the children
	for child_node in get_children():
		child_node.queue_free()
	current_string = ""


func _on_current_string_matches(string: String) -> void:
	#print("matches!")
	#print(string)
	# use call_deferred here to ensure that the new letter child node has been added
	call_deferred("play_text_match_effect")

func play_text_match_effect() -> void:
	var index: int = 0
	for letter in get_children():
		if letter is CastingTextChild:
			letter.hover_text(0.05*index)
		index+=1

func _on_current_string_typed(string: String) -> void:
	for letter in get_children():
		if letter is CastingTextChild:
			letter.stop_hover_text()
