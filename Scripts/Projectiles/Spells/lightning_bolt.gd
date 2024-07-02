extends ProjectileSpell
class_name LightningBolt

# Lightning bolt doesn't really care about it's collision shape
@onready var animation_player = $AnimationPlayer
# Lightning bolts expect to receive a player from the thunder storm spell
var enemy: EnemyClass

func _ready():
	print("Lightning bolt has spawned, todo add some timer")
	animation_player.play("lightning_strike")

func strike_enemy():
	spell_hit_body(enemy)
