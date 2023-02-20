extends PlayerState

var lastDir
var dir

func enter(msg := {}) -> void:
	if msg.has("doJump"):
		player.velocity.y = -player.jumpHeight
		player.snapVector = Vector2.ZERO
	if msg.has("doDrop"):
		player.drop()

func physicsUpdate(delta: float) -> void:
	
	#Add movement to velocity
	if (dir != 0):
		lastDir = dir
	dir = player.getDirection()

	if dir != 0:
		player.velocity.x = lerp(player.velocity.x, dir * player.walkSpeed, player.acceleration)
	else:
		player.velocity.x = lerp(player.velocity.x, 0, player.friction)

	#Gravity
	player.velocity.y += delta * player.gravity
	
	#Variable jump height
	if (!player.is_on_floor() && Input.is_action_just_released("jump") && player.velocity.y < 0):
		player.velocity.y *= player.jumpCancel

	#Apply Movement
	player.velocity = player.move_and_slide(player.velocity,Vector2.UP);

	#Landing
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			stateMachine.transitionTo("Idle")
		else:
			stateMachine.transitionTo("Run")

	#Touching Water
	if player.canSwim:
		stateMachine.transitionTo("Water")

	#Wall Sliding
	if player.isNearWall():
		print("Enter Wall Slide State")
		stateMachine.transitionTo("WallSlide",{wallDir = lastDir})
