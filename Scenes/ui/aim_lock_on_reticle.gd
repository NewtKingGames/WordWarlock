class_name Reticle extends Node2D

# TODO - could make this an enemy?
var target_node: Node2D:
	set(node):
		is_active = true if node else false
		target_node = node
var is_active: bool:
	set(flag):
		$Sprite2D.visible = flag
		is_active = flag
@export var reticle_speed: float = 1800.0
var player: Player


# TODO - to simplify these visual effects it'd be a lot cleaner to use a state machine
var is_in_steady_state = false
var tween_scale: Tween
var tween_rotation: Tween


# On object ready we set the postion of the object to where the player is and set the visibility false
func _ready():
	player = get_tree().get_first_node_in_group("player")
	is_active = false
	global_position = player.global_position
	#tween_scale = create_tween().set_loops()
	#tween_rotation = create_tween().set_loops()

func _process(delta):
	if target_node:
		# While distance to the target is above some threshold move there, otherwise  the position is hardcoded
		if global_position.distance_to(target_node.global_position) > 10:
			chase_state_effects()
			is_in_steady_state = false
			var vector_to_target: Vector2 = global_position.direction_to(target_node.global_position)
			global_position = global_position + vector_to_target * reticle_speed * delta
		else:
			steady_state_effects()
			is_in_steady_state = true
			global_position = target_node.global_position
	else:
		global_position = player.global_position

func set_target_node(node: Node2D):
	if node == target_node:
		return
	target_node = node
	if node != null:
		target_node.connect("tree_exiting", on_target_tree_exiting)

func steady_state_effects():
	# TODO how to stop these tweens then?
	if not is_in_steady_state:
	# For now maybe we set it to "breath" and slowly spin around an enemy?s
		tween_scale = create_tween().set_loops()
		tween_rotation = create_tween().set_loops()
		# TODO - tweens don't work great for rotation here, gotta fix that
		tween_rotation.tween_property(self, "rotation_degrees", 360, 3)
		tween_rotation.tween_property(self, "rotation_degrees", -360, 3)
		
		# Consider only tweening the sprite scale
		tween_scale.tween_property(self, "scale", Vector2(6, 6), .5)
		tween_scale.tween_property(self, "scale", Vector2(3, 3), .5)

func chase_state_effects():
	# TODO how to stop these tweens then?
	if is_in_steady_state:
	# For now maybe we set it to "breath" and slowly spin around an enemy?s
		tween_scale = create_tween()
		tween_rotation = create_tween()

# Necessary to avoid NPE's when an enemy is destroyed
func on_target_tree_exiting():
	target_node = null
