extends HBoxContainer

var heart = preload("res://assets/sprites/holyWater.png")
var heartEmpty = preload("res://assets/sprites/holyWaterDry.png")

var sM 

func _ready():
	sM = owner
	add_to_group("Persistent")
	add_to_group("Globals")

func updateHealth(value):
	for i in get_child_count():
		if value > i:
			get_child(i).texture = heart
		else:
			get_child(i).texture = heartEmpty

func loadData():
	if sM.state.sceneIndex.has("HP"):
		updateHealth(sM.state.sceneIndex["HP"])

func _on_Player_health_changed(new_hp):
	updateHealth(new_hp)
