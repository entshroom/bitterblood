#Virtual base class from which all states inherit
class_name State
extends Node

#Reference to the state machine, to call transition methods directly.
#The node that holds the state machine will assign itself to this variable.
var stateMachine = null

#Virtual function that receives inputs from the unhandled input callback.
func handleInput(_event := InputEvent) -> void:
	pass

#Virtual function that corresponds to _process()
func update(_delta: float) -> void:
	pass

#Virtual function that corresponds to _physics_process()
func physicsUpdate(_delta: float) -> void:
	pass

#Called by the sm when changing the active state. msg holds a dictionary of arbitrary data.
func enter(_msg := {}) -> void:
	pass

#Called by the sm before changing the active state. Cleans up the state.
func exit() -> void:
	pass
