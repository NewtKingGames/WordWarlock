extends Node2D

var child_text_scene: PackedScene = preload("res://Scenes/ui/casting_text_child.tscn")
var letter_position_offset: float = 20


# DELETE ME
#func _ready():
	#pass
	##add_letter("A")
	##await get_tree().create_timer(0.5).timeout
	##add_letter("B")
	##await get_tree().create_timer(0.5).timeout
	##delete_letter()
# DELETE ME
#func _process(delta):
	#if Input.is_action_just_pressed("left"):
		#add_letter("A")
	#if Input.is_action_just_pressed("right"):
		#add_letter("B")
	#if Input.is_action_just_pressed("down"):
		#delete_letter()

func add_letter(letter: String):
	slide_all_previous_letters_left()
	print("adding child")
	var child_text_node: CastingTextChild = child_text_scene.instantiate()
	child_text_node.text = letter
	add_child(child_text_node)

func slide_all_previous_letters_left():
	for letter in get_children():
		if letter is CastingTextChild:
			#letter.position.x = letter.position.x - letter_position_offset
			letter.other_letter_added_effect()
	
func slide_all_previous_letters_right():
	for letter in get_children():
		if letter is CastingTextChild:
			#letter.position.x = letter.position.x + letter_position_offset
			letter.other_letter_removed_effect()

func delete_letter():
	var total_children: int = get_child_count()
	if total_children == 0:
		print("skipping delete no children")
		return
	# THIS DOESNT WORK CORRECTLY BECAUSE OF HTE CAMERA AND SPRITE
	get_children()[total_children-1].remove()
	# TODO this isn't the best looking solution right now
	slide_all_previous_letters_right()

func clear_letters():
	# Directly call queue_free to delete the children
	for child_node in get_children():
		child_node.queue_free()
