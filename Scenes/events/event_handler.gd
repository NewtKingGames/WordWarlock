class_name EventHandler
extends Node

# TODO - this is simply not flexible enough... keep working on it
# expects Node,String
@export_group("Subsribers")
@export var nodes_to_subscribe: Array[Node] = []
@export var signals_to_subscribe: Array[String] = []

# expects Node,Command
@export_group("Executors")
@export var nodes_to_command: Array[Node] = []
@export var commands_to_execute: Array[Command] = []


var subscribed_signals: int = 0
var signals_received: int = 0

func _ready() -> void:
	#for node in nodes_and_signals_to_subscribe:
		#node = node as Node
		#if not node:
			#print("SOMETHING WENT WRONG SKIPPING")
			#continue
		#node.connect(nodes_and_commands_to_execute[node], _on_signal_received)
		#subscribed_signals += 1
	var current_index: int
	for node in nodes_to_subscribe:
		node.connect(signals_to_subscribe[current_index], _on_signal_received)
		subscribed_signals += 1
		current_index +=1

func _on_signal_received() -> void:
	signals_received += 1
	if signals_received >= subscribed_signals:
		execute_commands()
		
func execute_commands() -> void:
	#for node in nodes_and_commands_to_execute:
		#node = node as Node
		#if not node:
			#print("SOMETHING WENT WRONG SKIPPING")
			#continue
		#var command: Command = nodes_and_commands_to_execute[node]
		#command.do_action(node)
	var current_index: int = 0
	for node in nodes_to_command:
		commands_to_execute[current_index].do_action(node)
		current_index += 1
	queue_free()
