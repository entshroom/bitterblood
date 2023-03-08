extends StaticBody2D

var destroyed = false
var nm

func _ready():
	nm = owner.name

	add_to_group("Persistent")
	add_to_group("Globals")

func _on_Area2D_area_entered(area):
	if area.owner.hasKey == true:
		area.owner.hasKey = false
		destroyed = true
		saveData()
		queue_free()

func saveData():
	owner.state.sceneIndex[nm][name + "Destroyed"] = destroyed
	
func loadData():
	if owner.state.sceneIndex[nm].has(name + "Destroyed"):
		destroyed = owner.state.sceneIndex[nm][name + "Destroyed"]

	if destroyed:
		queue_free()
