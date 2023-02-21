extends PlayerState

var dir

func enter(msg := {}) -> void:
	if msg.has("wallDir"):
		dir = msg.wallDir

#Slide physics
func physicsUpdate(delta: float) -> void:
		#Gravity
		player.velocity.y += delta * player.gravity
		player.velocity.y = clamp(player.velocity.y, 0, 250)
		
		#Wall Jumping (horrible code look away!!)
		if Input.is_action_pressed("jump") && Input.is_action_pressed("right") && dir == -1:
			player.velocity.x = 450 * -dir
			player.velocity.y = -player.jumpHeight
			stateMachine.transitionTo("Air")
		elif Input.is_action_pressed("jump") && Input.is_action_pressed("left") && dir == 1:
			player.velocity.x = 450 * dir
			player.velocity.y = -player.jumpHeight
			stateMachine.transitionTo("Air")
		

		#Apply Movement
		player.velocity = player.move_and_slide(player.velocity,Vector2.UP);
		
		#Return to Idle or Air
		if player.is_on_floor():
			stateMachine.transitionTo("Idle")
		elif !player.isNearWall():
			stateMachine.transitionTo("Air")
