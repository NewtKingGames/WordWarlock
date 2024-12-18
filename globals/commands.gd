# autoloaded as "Commands"
extends Node

func call_method(object: Node, method_name: String, args: Array) -> void:
	if args.size() > 0:
		object.call(method_name, args)
	else:
		object.call(method_name)
	
