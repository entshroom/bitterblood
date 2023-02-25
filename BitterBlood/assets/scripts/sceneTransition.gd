extends Area2D

export(String, FILE, "*.tscn") var sceneToLoad
export(int) var direction = 1

onready var collider = $sceneData/sceneDataCollider

var sM

func _ready():
	sM = owner
	collider.position.x *= direction

func _on_sceneTransition_body_entered(_body):
	if ResourceLoader.exists(sceneToLoad):
		var _error = get_tree().change_scene(sceneToLoad)


func _on_sceneData_body_entered(_body):
	sM.pushUpdate()
