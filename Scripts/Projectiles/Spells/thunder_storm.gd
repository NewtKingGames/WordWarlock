extends Spell
class_name ThunderStorm

@export var num_lightning_bolts: int

# Hits X number of random enemies around the player with a lightning_bolt spell
func _ready():
	var enemies_in_zone: Array[EnemyClass] = get_enemies_in_zone()
	for enemy: EnemyClass in enemies_in_zone:
		print("Found enemy in zone")
		print(enemy)
	


func get_enemies_in_zone() -> Array[EnemyClass]:
	var overlapping_bodies: Array[Node2D] = get_overlapping_bodies()
	var overlapping_enemies: Array[EnemyClass] = []
	overlapping_enemies.resize(num_lightning_bolts) # Maybe a better way to construct the array with the correct size initially?
	var num_enemies_added = 0
	for over_lapping_body: Node2D in overlapping_bodies:
		print("overlapping bodies")
		if over_lapping_body is EnemyClass:
			overlapping_enemies[num_enemies_added] = over_lapping_body
	return overlapping_enemies
	
