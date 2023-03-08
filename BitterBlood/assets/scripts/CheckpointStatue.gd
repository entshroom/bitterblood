extends Area2D

var sM

func _ready():
	sM = owner
	
	
func saveData(pos):
	sM.state.sceneIndex["RespawnPosition"] = pos

func _on_CheckpointStatue_area_entered(_area):
	saveData(position)
	print("Saving Position!")
