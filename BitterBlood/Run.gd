extends PlayerState


func physicsUpdate(delta: float) -> void:
	if !player.is_on_floor():
		stateMachine.transitionTo("Air")
		return
	
	#Add movement to velocity
	player.velocity.x = player.getDirection() * player.walkSpeed
	
	#Get floor normal
	var floorNormal = player.get_floor_normal()

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
	elif is_equal_approx(player.getDirection(),0.0):
		stateMachine.transitionTo("Idle")
	
	#Touching Water
	if player.canSwim:
		stateMachine.transitionTo("Water")

#Reset Snap Vector
func exit() -> void:
	player.snapVector = Vector2.ZERO
