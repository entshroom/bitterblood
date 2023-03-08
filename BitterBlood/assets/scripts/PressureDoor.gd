extends StaticBody2D

var origin
var alwaysOpen = false

var nm

func _ready():
	
	add_to_group("Persistent")
	add_to_group("Globals")

	origin = position
	nm = owner.name

func _on_PressurePlate_plateDown(value):
	if !alwaysOpen:
		if value:
			position.y += 600
		else:
			position.y = origin.y
		
func saveData():
	if position.y != origin.y:
		alwaysOpen = true
	owner.state.sceneIndex[nm][name + "AlwaysOpen"] = alwaysOpen
	
func loadData():
	if owner.state.sceneIndex[nm].has(name + "AlwaysOpen"):
		alwaysOpen = owner.state.sceneIndex[nm][name + "AlwaysOpen"]
		if alwaysOpen:
			position.y += 600
