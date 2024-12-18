class_name Command
extends Resource


@export var call_method: String
@export var params:Array

func do_action(object: Node) -> void:
	Commands.call_method(object, call_method, params)
