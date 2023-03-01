extends PlayerState

func enter(msg := {}) -> void:
	#Enable Area2D and play Animation
	print("Trans Rights!")


func endAnimation():
	#stateMachine.transitionTo("Run")
	pass

func exit() -> void:
	pass
		#Disable Area2D
		#player.rapier.monitoring = false
		#player.rapier.monitorable = false
