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
	
	add_to_group("Persistent")
	add_to_group("Globals")

func _process(_delta):
	
	#Clamp value
	bloodlust = clamp(bloodlust, min_value, max_value)
	
	match(bloodState):
	
		state.DRAIN:
			if bloodlust > 0:
				bloodlust -= drainRate
				value = bloodlust
			
			if bloodlust >= 100:
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
		
func saveData():
	
	#BloodState
	owner.sM.state.sceneIndex["BloodState"] = bloodState
	
	#Bloodlust
	owner.sM.state.sceneIndex["Bloodlust"] = bloodlust

func loadData():
	
	#BloodState
	if owner.sM.state.sceneIndex.has("BloodState"):
		bloodState = owner.sM.state.sceneIndex["BloodState"]
	
	#Bloodlust
	if owner.sM.state.sceneIndex.has("Bloodlust"):
		bloodlust = owner.sM.state.sceneIndex["Bloodlust"]
		value = bloodlust
	
