extends PlayerState

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
	if Input.is_action_just_pressed("jump") && player.canJump:
		#Because Air handles two different actions, we can use message to
		#tell the state what it should be doing.
		stateMachine.transitionTo("Air",{doJump = true})
	elif Input.is_action_just_pressed("left") && player.canMove || Input.is_action_just_pressed("right") && player.canMove:
		stateMachine.transitionTo("Run")
	
	#Attack
	if player.canAttack && Input.is_action_just_pressed("attack"):
		stateMachine.transitionTo("Attack")

	#Knockback
	if player.knockback:
		player.velocity.x = player.knockbackForce * -player.direction
		player.velocity.y = -player.knockbackForce
		stateMachine.transitionTo("Knockback")

	#Shoot Cannon
	if Input.is_action_just_pressed("brimstoneCannon") && player.brimstoneCannon:
		stateMachine.transitionTo("BrimstoneCannon")

	#Dash 
	if player.doubleTap && player.hasDash && player.canDash:
		stateMachine.transitionTo("Dash")

#Continue leftover movement
func physicsUpdate(_delta: float) -> void:

	#slow to a stop
	player.velocity.x = lerp(player.velocity.x, 0, player.friction)
	
	#apply leftover movement
	player.velocity = player.move_and_slide_with_snap(player.velocity,player.snapVector,Vector2.UP);
