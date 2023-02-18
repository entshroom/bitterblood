extends PlayerState


func enter(msg := {}) -> void:
	if msg.has("doJump"):
		player.velocity.y = -player.jumpHeight
		player.snapVector = Vector2.ZERO
	if msg.has("doDrop"):
		player.drop()

func physicsUpdate(delta: float) -> void:
	
	#Add movement to velocity
	player.velocity.x = player.getDirection() * player.walkSpeed

	#Gravity
	player.velocity.y += delta * player.gravity

	#Apply Movement
	player.velocity = player.move_and_slide_with_snap(player.velocity,player.snapVector,Vector2.UP);

	#Landing
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			stateMachine.transitionTo("Idle")
		else:
			stateMachine.transitionTo("Run")

	#Touching Water
	if player.canSwim:
		stateMachine.transitionTo("Water")
