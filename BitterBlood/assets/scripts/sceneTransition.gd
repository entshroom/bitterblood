extends Area2D

export(String, FILE, "*.tscn") var sceneToLoad
export(int) var direction = 1
export(Vector2) var nextRoomCoords

onready var collider = $sceneData/sceneDataCollider

var sM

func _ready():
	sM = owner
	collider.position.x *= direction

func localSave():

	#Positional Data
	sM.state.sceneIndex["NextPlayerPosition"] = nextRoomCoords
	
func _on_sceneTransition_body_entered(_body):
	if ResourceLoader.exists(sceneToLoad):
		print("Loading Sene!")
		var _error = get_tree().change_scene(sceneToLoad)
		print(_error)


func _on_sceneData_body_entered(_body):
	sM.pushUpdate()
	localSave()
