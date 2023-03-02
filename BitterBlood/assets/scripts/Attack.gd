extends PlayerState

export var animationOver = false

func enter(msg := {}) -> void:
	#play Animation
	animationOver = false
	if !player.anim.is_playing():
		player.anim.play("Attack")

func update(_delta: float) -> void:
	if animationOver:
		player.anim.stop(true)
		stateMachine.transitionTo("Run")

func physicsUpdate(_delta: float) -> void:
	
	#slow to a stop
	player.velocity.x = lerp(player.velocity.x, 0, player.friction)
	
	#apply leftover movement
	player.velocity = player.move_and_slide_with_snap(player.velocity,player.snapVector,Vector2.UP);
