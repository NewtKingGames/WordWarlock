extends ProjectileSpell
class_name LightningBolt

# Lightning bolt doesn't really care about it's collision shape
@onready var animation_player = $AnimationPlayer

signal lightning_bolt_destroyed()
# Lightning bolts expect to receive a player from the thunder storm spell
var enemy: EnemyClass

func _ready():
	animation_player.play("lightning_strike")
	super._ready()

func _process(_delta):
	# Have the lightning bolt follow the enemy
	if enemy == null:
		return
	global_position.x = enemy.global_position.x

func strike_enemy():
	spell_hit_body(enemy)

func _on_emit_noise_finished():
	lightning_bolt_destroyed.emit()
	queue_free()
