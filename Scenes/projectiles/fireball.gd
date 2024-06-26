extends Area2D

var direction: Vector2 = Vector2.UP
var speed: float = 10

func _update(delta):
	position += direction*speed*delta

func _on_body_entered(body: Node2D):
	print("Fireball hit something!")
	print(body)
