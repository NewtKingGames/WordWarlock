extends Spell
class_name Thunderstorm
# Hits X number of random enemies around the player with a lightning_bolt spell


@export var max_num_lightning_bolts: int
var num_lightning_bolts_spawned: int = 0
var num_lightning_bolts_destroyed: int = 0
@onready var lightning_bolts = $LightningBolts


var lightning_bolt_scene: PackedScene = preload("res://Scenes/projectiles/lightning_bolt.tscn")

var is_first_run: bool = true

func _physics_process(delta):
	# This needs to be done within physics_processs since we are using overlaps with
	if is_first_run:
		# TODO add some fun delay so the lightning isn't all at once
		var enemies_in_zone: Array[EnemyClass] = get_enemies_in_zone()
		if enemies_in_zone[0] == null:
			# No enemies nearby
			queue_free()
		for enemy: EnemyClass in enemies_in_zone:
			if enemy != null:
				spawn_lightning_bolt(enemy)
	is_first_run = false


func spawn_lightning_bolts(enemies: Array[EnemyClass], number_lightning_bolts: int):
	pass

func spawn_lightning_bolt(enemy: EnemyClass):
	var lightning_bolt: LightningBolt = lightning_bolt_scene.instantiate()
	lightning_bolt.connect("lightning_bolt_destroyed", _on_lightning_bolt_destroyed)
	lightning_bolt.enemy = enemy
	lightning_bolt.position = enemy.global_position + Vector2.UP * 120# TODO MOVE IT ABOVE
	lightning_bolts.add_child(lightning_bolt)

func _on_lightning_bolt_destroyed():
	num_lightning_bolts_destroyed+=1
	if num_lightning_bolts_spawned == num_lightning_bolts_destroyed:
		queue_free()

func get_enemies_in_zone() -> Array[EnemyClass]:
	var overlapping_bodies: Array[Node2D] = get_overlapping_bodies()
	var overlapping_enemies: Array[EnemyClass] = []
	overlapping_enemies.resize(max_num_lightning_bolts) # Maybe a better way to construct the array with the correct size initially?
	for over_lapping_body: Node2D in overlapping_bodies:
		if over_lapping_body is EnemyClass:
			overlapping_enemies[num_lightning_bolts_spawned] = over_lapping_body
			num_lightning_bolts_spawned+=1
	return overlapping_enemies
	
