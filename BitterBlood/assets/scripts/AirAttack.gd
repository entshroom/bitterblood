extends PlayerState

export var animationOver = false

func enter(msg := {}) -> void:
	
	#Propel Forward
	player.velocity.y = 0
	player.velocity.x = 500 * player.getDirection()
	 
	#play Animation
	animationOver = false
	if !player.anim.is_playing():
		player.anim.play("Attack")

func update(_delta: float) -> void:
	if animationOver:
		player.anim.stop(true)
		stateMachine.transitionTo("Run")
		print("Back to run...")

func physicsUpdate(_delta: float) -> void:
	
	#apply leftover movement
	player.velocity = player.move_and_slide_with_snap(player.velocity,player.snapVector,Vector2.UP);
