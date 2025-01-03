extends Node2D
@onready var area_2d: Area2D = $Area2D

var is_active: bool = true

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(body: Node2D) -> void:
	if is_active:
		Events.start_curse.emit(Curse.CURSE_TYPE.BLIND_KEYS)
		is_active = false

func stop_curse() -> void:
	pass
