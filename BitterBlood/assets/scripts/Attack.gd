extends PlayerState

func enter(msg := {}) -> void:
	#play Animation
	player.anim.play("Attack")


func endAnimation():
	stateMachine.transitionTo("Run")

func exit() -> void:
		#Disable Area2D
		player.rapier.monitoring = false
		player.rapier.monitorable = false
