extends EnemyClass

@onready var target_enemy_sprite: AnimatedSprite2D = $AnimatedSprite2D

func hit(damage: float):
	target_enemy_sprite.play("damage")


func _physics_process(delta: float) -> void:
	pass
