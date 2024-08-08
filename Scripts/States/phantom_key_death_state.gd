extends EnemyDeath
class_name PhantomKeyDeath


func Enter():
	print(enemy.keyboard_letter)
	if enemy.keyboard_letter:
		enemy.keyboard_letter.letter_active = true
	enemy.queue_free()
