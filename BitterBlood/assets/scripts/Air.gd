extends PlayerState

var lastDir
var dir
var airControl = true

func enter(msg := {}) -> void:
	if msg.has("doJump"):
		player.velocity.y = -player.jumpHeight
		player.snapVector = Vector2.ZERO
	if msg.has("doDrop"):
		player.drop()
	if (msg.has("airToggle")):
		airControl = msg.airToggle

func physicsUpdate(delta: float) -> void:
	
	#Add movement to velocity
	if (dir != 0):
		lastDir = dir
	dir = player.getDirection()

	if airControl:
		if dir != 0:
			player.velocity.x = lerp(player.velocity.x, dir * player.walkSpeed, player.acceleration)
			pass
		else:
			player.velocity.x = lerp(player.velocity.x, 0, player.friction)
			pass

	#Gravity
	if player.velocity.y > 0:
		player.velocity.y += delta * player.gravity * 1.7
	else:
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
		stateMachine.transitionTo("WallSlide",{wallDir = lastDir})

#Reset State Vars
func exit() -> void:
	airControl = true;
	pass
