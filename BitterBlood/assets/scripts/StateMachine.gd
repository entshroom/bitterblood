#Generic state machine. Initializes states and delegates engine callbacks (like _process())
class_name StateMachine
extends Node

#Emitted when transitioning to a new state.
signal transitioned(stateName)

#Path to the default active state.
export var initialState := NodePath()

#The current active state.
onready var state: State = get_node(initialState)

#I really don't understand this one.
func _ready() -> void:
	yield(owner, "ready")
	for child in get_children():
		child.stateMachine = self
	state.enter()

#Get node callbacks and delegate to state objects
func _unhandled_input(event: InputEvent) -> void:
	state.handleInput(event)

func _process(delta: float) -> void:
	state.update(delta)
	#print(state)

func _physics_process(delta: float) -> void:
	state.physicsUpdate(delta)

#This function does several things:
#	calls the current state's exit function.
#	changes the active state and calls it's enter function.
#	takes a dictionary in the form of 'msg' to five to the next state
func transitionTo(targetStateName: String, msg: Dictionary = {}) -> void:
	#Safety check
	if not has_node(targetStateName):
		return

	state.exit()
	state = get_node(targetStateName)
	state.enter(msg)
	emit_signal("transitioned", state.name)
