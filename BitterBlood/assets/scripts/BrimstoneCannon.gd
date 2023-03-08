extends PlayerState

var countdown = 8

func enter(_msg := {}) -> void:
	var a = player.cannonBall.instance()
	a.speed = 2000
	a.position = player.position
	a.direction = player.direction
	get_node("/root/" + player.sM.name + "/Environment").add_child(a)
	player.takeDamage(1, false)
	player.velocity.x = 900 * -player.direction
	player.velocity.y = 0

func update(_delta: float) -> void:
	countdown -= 1
	
	if countdown <= 0:
		countdown = 8
		stateMachine.transitionTo("Idle")

func physicsUpdate(_delta: float) -> void:
	
	#apply leftover movement
	player.velocity = player.move_and_slide(player.velocity,Vector2.UP);

