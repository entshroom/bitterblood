extends PlayerState

var countdown = 8

func enter(_msg := {}) -> void:
	player.velocity.x = 4000 * player.direction
	player.velocity.y = 0
	player.invincible = true
	player.canDash = false
	player.dtapTime = 0
	player.doubleTap = false
	player.dashTimer.start(1)

func update(_delta: float) -> void:
	countdown -= 1
	
	if countdown <= 0:
		countdown = 8
		player.invincible = false
		stateMachine.transitionTo("Idle")

func physicsUpdate(_delta: float) -> void:
	
	#apply movement
	player.velocity = player.move_and_slide(player.velocity,Vector2.UP);

