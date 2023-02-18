#Boilerplate class that allows proper debugging for states that rely on the owner property
class_name PlayerState
extends State

#Type reference to the player node
var player: Player

#Debugging shit
func _ready() -> void:
	yield(owner,"ready")
	player = owner as Player
	assert(player != null)
