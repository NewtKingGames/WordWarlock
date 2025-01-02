extends Node
class_name StateMachine

@export var initial_state: State
var current_state : State
# Dictionary of states, keyed by the state node name
var states : Dictionary = {}
var input_enabled: bool = true

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float):
	if current_state:
		current_state.Update(delta)
	
func _physics_process(delta: float):
	if current_state:
		current_state.Physics_Update(delta)

func _input(event: InputEvent):
	#print("within device")
	#print(event.device)
	if current_state and input_enabled:
		current_state.Handle_Input(event)


func handle_outside_input(event: InputEvent) -> void:
	#print(event)
	#print("outside device")
	#print(event.device)
	if current_state:
		current_state.Handle_Input(event)

func on_child_transition(state: State, new_state_name: String):
	if state != current_state:
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()

	new_state.Enter()
	current_state = new_state

# Special transition for state changes from outside the characters control like damage
func on_outside_transition(new_state_name: String):
	if current_state.name.to_lower() == new_state_name.to_lower():
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()

	new_state.Enter()
	current_state = new_state
