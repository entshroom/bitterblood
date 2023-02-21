extends PlayerState


func physicsUpdate(delta: float) -> void:
	if !player.is_on_floor():
		stateMachine.transitionTo("Air")
		return
	
	#Add movement to velocity
	var dir = player.getDirection()
	if dir != 0:
		player.velocity.x = lerp(player.velocity.x, dir * player.walkSpeed, player.acceleration)
	else:
		player.velocity.x = lerp(player.velocity.x, 0, player.friction)
	
	#Get floor normal and angle
	var floorNormal = player.get_floor_normal()
	var floorAngle = player.get_floor_angle()

	#Configure Slope Snap
	if (player.is_on_floor()):
		player.snapVector = -floorNormal * 5;
	else:
		floorNormal = Vector2.UP
		player.snapVector = Vector2.ZERO

	#Gravity
	player.velocity.y += delta * player.gravity

	#Apply Movement
	player.velocity += -floorNormal;
	player.velocity = player.move_and_slide_with_snap(player.velocity,player.snapVector,Vector2.UP);

	#Fall through Platforms
	if Input.is_action_just_pressed("down"):
		player.drop();

	#Jump
	if Input.is_action_just_pressed("jump") && player.is_on_floor():
		stateMachine.transitionTo("Air",{doJump = true})
	elif is_equal_approx(dir,0.0):
		stateMachine.transitionTo("Idle")
	
	#Touching Water
	if player.canSwim:
		stateMachine.transitionTo("Water")
		
	#Sliding
	if floorAngle > player.slopeThreshold:
		stateMachine.transitionTo("Slide")

#Reset Snap Vector
func exit() -> void:
	#player.snapVector = Vector2.ZERO
	pass
