extends Area2D
class_name BatSpit


var speed: float
var direction: Vector2

func _process(delta):
	position += direction*speed*delta




func _on_body_entered(body):
	if body is Player:
		body.hit(10, direction * 10) # TODO need to figure out if this is a good start for knockback
	queue_free()
