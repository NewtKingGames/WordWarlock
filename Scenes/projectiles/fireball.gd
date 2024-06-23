extends Area2D


func _ready():
	pass

func _update(_delta):
	pass

func _on_body_entered(body):
	print("Fireball hit something!")
	print(body)
