extends PlayerState

func enter(msg := {}) -> void:
	#Enable Area2D and play Animation
	player.rapier.monitoring = true
	player.rapier.monitorable = true
	player.anim.play("Attack")


func endAnimation():
	stateMachine.transitionTo("Run")

func exit() -> void:
		#Disable Area2D
		player.rapier.monitoring = false
		player.rapier.monitorable = false
