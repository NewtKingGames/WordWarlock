class_name SpellStackWord extends Label

var word: String:
	set(string):
		word = string
		text = string
var position_in_stack: int # does it make sense to have this here or should the parent be in control of that?

# TODO - this is really gross
func _process(delta: float) -> void:
	pivot_offset = Vector2(size.x/2, size.y/2)
