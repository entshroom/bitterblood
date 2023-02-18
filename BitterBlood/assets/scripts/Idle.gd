extends PlayerState

#Set player's speed to 0
func enter(_msg := {}) -> void:
	#All properties that we need can be accessed through 'owner' (player)
	player.velocity = Vector2.ZERO

#Handle transitions to other states
func update(_delta: float) -> void:
	#Air Check
	if !player.is_on_floor():
		stateMachine.transitionTo("Air")
		return

	#Fall through Platforms
	if Input.is_action_just_pressed("down"):
		stateMachine.transitionTo("Air",{doDrop = true})

	#Jump
	if Input.is_action_just_pressed("jump"):
		#Because Air handles two different actions, we can use message to
		#tell the state what it should be doing.
		stateMachine.transitionTo("Air",{doJump = true})
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		stateMachine.transitionTo("Run")
