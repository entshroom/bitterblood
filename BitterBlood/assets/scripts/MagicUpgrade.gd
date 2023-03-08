extends Area2D

export(int) var heartCount

signal upgradeHealth

var health

var destroyed = false

func _ready():
	health = get_node("/root/" + owner.name + "/UI/Control")
	var _error = connect("upgradeHealth",health,"addHearts")
	
	add_to_group("Persistent")
	add_to_group("Globals")
	

func _on_HeartContainer_body_entered(body):
	emit_signal("upgradeHealth", heartCount)
	body.hpMax += heartCount
	body.setHealth()
	destroyed = true
	saveData()
	queue_free()
	
func saveData():
	owner.state.sceneIndex[owner.name][name+"Destroyed"] = destroyed
	
func loadData():
	if owner.state.sceneIndex[owner.name].has(name+"Destroyed"):
		destroyed = owner.state.sceneIndex[owner.name][name+"Destroyed"]

	if destroyed:
		queue_free()

