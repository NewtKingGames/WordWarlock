extends State
class_name EnemyState

var player: Player
@onready var enemy: EnemyClass = $"../.."



# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
