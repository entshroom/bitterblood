extends PlayerState

var jumpForce = 650.0

#Slide physics
func physicsUpdate(delta: float) -> void:

	#Get Floor Normal
	var floorNormal = player.get_floor_normal()
	
	#Add Normal to Velocity
	player.velocity += floorNormal
	
	#You're too slow!
	if player.velocity.y > 0:
		jumpForce += 8
	else:
		jumpForce = 1200.0
	
	jumpForce = clamp(jumpForce, 1200.0, 2400.0)
	
	print(jumpForce)

	#Gravity
	player.velocity.y += delta * player.gravity
	
	#Apply Movement
	player.velocity = player.move_and_slide(player.velocity,Vector2.UP);

	#Measure Angle
	var floorAngle = player.get_floor_angle()
	
	#Go back to Idle
	if floorAngle < player.slopeThreshold:
		stateMachine.transitionTo("Idle")
		
	#Jump Off
	if Input.is_action_just_pressed("jump") && player.is_on_floor():
		player.velocity.y = -jumpForce
		player.velocity.x = jumpForce * player.direction
		stateMachine.transitionTo("Air",{airToggle = false})


func exit() -> void:
	jumpForce = 650.0
	pass
