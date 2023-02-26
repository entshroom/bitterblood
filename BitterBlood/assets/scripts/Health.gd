extends HBoxContainer

var heartNode = preload("res://assets/prefabs/Heart.tscn")
var heart = preload("res://assets/sprites/holyWater.png")
var heartEmpty = preload("res://assets/sprites/holyWaterDry.png")

var sM 

func _ready():
	sM = owner
	add_to_group("Persistent")
	add_to_group("Globals")
	
	#Check for existing Heart Data
	if sM.state.sceneIndex.has("HeartCount"):
		for n in sM.state.sceneIndex["HeartCount"]:
			var h = heartNode.instance()
			self.add_child(h)
	else:
		for n in 5:
			var h = heartNode.instance()
			self.add_child(h)

func updateHealth(value):
	for i in get_child_count():
		if value > i:
			get_child(i).texture = heart
		else:
			get_child(i).texture = heartEmpty

func addHearts(value):
	for n in value:
		print("Duplicating...")
		var h = heartNode.instance()
		self.add_child(h)
	updateHealth(get_child_count())

func loadData():
	if sM.state.sceneIndex.has("HP"):
		updateHealth(sM.state.sceneIndex["HP"])

func saveData():
	#Save total hearts
	sM.state.sceneIndex["HeartCount"] = get_child_count()

func _on_Player_health_changed(new_hp):
	updateHealth(new_hp)
