class_name SpellStackWord extends Label

var word: String:
	set(string):
		word = string
		text = string
var position_in_stack: int # does it make sense to have this here or should the parent be in control of that?

@export var HIGHLIGHT_COLOR: Color

func _ready() -> void:
	var tween: Tween = create_tween().set_loops()
	tween.tween_property(self, "modulate", HIGHLIGHT_COLOR, 0.5)
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)

func _process(delta: float) -> void:
	pivot_offset = Vector2(size.x/2, size.y/2)
