class_name Reticle extends Node2D

# TODO - could make this an enemy?
var target_node: Node2D
var is_active: bool:
	set(flag):
		$Sprite2D.visible = flag
		is_active = flag
@export var reticle_speed: float = 400.0
var player: Player

# On object ready we set the postion of the object to where the player is and set the visibility false
func _ready():
	player = get_tree().get_first_node_in_group("player")
	is_active = false
	global_position = player.global_position

func _process(delta):
	if target_node:
		# While distance to the target is above some threshold move there, otherwise  the position is hardcoded
		if global_position.distance_to(target_node.global_position) > 10:
			var vector_to_target: Vector2 = global_position.direction_to(target_node.global_position)
			position = position + vector_to_target * reticle_speed * delta
		else:
			global_position = target_node.global_position
	else:
		global_position = player.global_position

func set_target_node(node: Node2D):
	if node == target_node:
		return
	# If the reticle was previously not set auto
	#if not is_active:	
	is_active = true if node else false
	target_node = node
	if node != null:
		target_node.connect("tree_exiting", on_target_tree_exiting)

# Necessary to avoid NPE's
func on_target_tree_exiting():
	print("the target is being removed from the scene!!")
	target_node = null
	is_active = false
