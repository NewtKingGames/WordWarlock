extends Node


var bat_spit_scene: PackedScene = load("res://Scenes/enemies/bat_spit.tscn")

func _ready():
	Events.bat_spit.connect(on_bat_spit)
	# Connect all of the required enemy signals to this node
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")
	for enemy: EnemyClass in enemies:
		if enemy is PhantomKey:
			enemy = enemy as PhantomKey
			enemy.connect("keyboard_letter_item_dropped", on_keyboard_letter_item_dropped)
	
# If you start to add many more enemies which shoot consider making all of the shoot signals pass 
# in the direction and speed as you do now BUT ALSO pass in the packed scene so that way the level doesn't have to care
func on_bat_spit(bat_spit_speed: float, direction: Vector2, position: Vector2):
	var bat_spit: BatSpit = bat_spit_scene.instantiate()
	bat_spit.speed = bat_spit_speed
	bat_spit.direction = direction
	bat_spit.position = position
	bat_spit.rotation = direction.angle()
	add_child(bat_spit)

# Is it better in general to pass the instantiated scene or is it better to pass properties and instantiate it here?
func on_keyboard_letter_item_dropped(keyboard_letter_item: KeyboardLetterPickupItem):
	add_child(keyboard_letter_item)
	
