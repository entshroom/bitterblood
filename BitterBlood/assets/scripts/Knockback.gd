extends PlayerState

var canEnd = false

func enter(_msg := {}) -> void:
	player.knockbackTimer.start(0.1)


func physicsUpdate(delta: float) -> void:
	if player.is_on_floor() && canEnd:
		player.knockback = false
		stateMachine.transitionTo("Idle")

	#Gravity
	player.velocity.y += delta * player.gravity
		
	#Apply Movement
	player.velocity = player.move_and_slide(player.velocity,Vector2.UP);

func exit() -> void:
	canEnd = false


func _on_Timer_timeout():
	canEnd = true
