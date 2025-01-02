extends State
class_name Player_Idle

@onready var player = $"../.."
@onready var character_animated_sprite_2d = $"../../CharacterAnimatedSprite2D"

func Enter():
	character_animated_sprite_2d.play("idle")
	player.velocity = Vector2.ZERO

func Exit():
	character_animated_sprite_2d.stop()

func Update(delta: float) -> void:
	if Input.get_vector("down","up","right","left"):
		Transitioned.emit(self, "move")

func Handle_Input(input: InputEvent) -> void:
	#if input is InputEventKey or input is InputEventAction:
		#print("this event!")
		#print(input)
		#print(input.is_action("left"))
	#print(input.is_action_pressed("left"))
	#if Input.get_vector("down","up","right","left"):
		#print("within input vector")
		#Transitioned.emit(self, "move")
	if input.is_action_pressed("enter"):
		Transitioned.emit(self, "cast")
