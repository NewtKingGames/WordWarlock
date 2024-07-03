extends ProjectileSpell
class_name LightningBolt

# Lightning bolt doesn't really care about it's collision shape
@onready var animation_player = $AnimationPlayer

signal lightning_bolt_destroyed()
# Lightning bolts expect to receive a player from the thunder storm spell
var enemy: EnemyClass

func _ready():
	animation_player.play("lightning_strike")

func _process(_delta):
	# Have the lightning bolt follow the enemy
	position.x = enemy.position.x

func strike_enemy():
	spell_hit_body(enemy)
	lightning_bolt_destroyed.emit()
	queue_free()
	

