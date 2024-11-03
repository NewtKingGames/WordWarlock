class_name SpellStackWord extends Label

var word: String:
	set(string):
		word = string
		text = string
var position_in_stack: int # does it make sense to have this here or should the parent be in control of that?

