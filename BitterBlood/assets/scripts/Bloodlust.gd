extends ProgressBar

export(float) var drainRate

var bloodlust = 90
var bloodState

enum state{
	DRAIN
	EMPOWERED
}

func _ready():
	bloodState = state.DRAIN

func _process(_delta):
	
	#Clamp value
	bloodlust = clamp(bloodlust, min_value, max_value)
	
	match(bloodState):
	
		state.DRAIN:
			if bloodlust > 0 && bloodlust < 100:
				bloodlust -= drainRate
				value = bloodlust
			else:
				bloodState = state.EMPOWERED
				get_tree().call_group("EnemyLogic", "toggleBloodlust")
		
		state.EMPOWERED:
			if bloodlust > 0:
				bloodlust -= drainRate * 1.5
				value = bloodlust
			else:
				get_tree().call_group("EnemyLogic", "toggleBloodlust")
				bloodState = state.DRAIN

func addBloodlust(amount):
	if bloodState != state.EMPOWERED:
		bloodlust += amount
