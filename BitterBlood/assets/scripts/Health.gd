extends Control

var heartNode = preload("res://assets/prefabs/Heart.tscn")
var heart = preload("res://assets/sprites/UI/Heart.png")
var heartEmpty = preload("res://assets/sprites/UI/HeartEmpty.png")

onready var healthNode = $Health
onready var bloodMeter = $RibbonTop/Bloodlust
onready var ribbonTop = $RibbonTop
onready var ribbonBottom = $RibbonBottom

var sM 

#Get Player Node
var player

func _ready():
	
	#Determine owner and assign groups
	sM = owner
	add_to_group("Persistent")
	add_to_group("Globals")
	
	#Get Player
	player = get_node("/root/" + sM.name + "/Player")
	
	#Connect Signals
	player.connect("bloodlust_gained", bloodMeter, "addBloodlust")
	
	#Check for existing Heart Data
	if sM.state.sceneIndex.has("HeartCount"):
		for n in sM.state.sceneIndex["HeartCount"]:
			var h = heartNode.instance()
			healthNode.add_child(h)
	else:
		for n in 3:
			var h = heartNode.instance()
			healthNode.add_child(h)

func updateHealth(value):
	for i in healthNode.get_child_count():
		if value > i:
			healthNode.get_child(i).texture = heart
		else:
			healthNode.get_child(i).texture = heartEmpty

func addHearts(value):
	for n in value:
		var h = heartNode.instance()
		healthNode.add_child(h)
		
		#Stretch UI
		ribbonTop.rect_size.x += 50
	updateHealth(healthNode.get_child_count())
	
	ribbonBottom.rect_size.x = ribbonTop.rect_size.x
	bloodMeter.rect_size.x = ribbonTop.rect_size.x - 71

func _on_Player_health_changed(new_hp):
	updateHealth(new_hp)

func loadData():
	if sM.state.sceneIndex.has("HP"):
		updateHealth(sM.state.sceneIndex["HP"])

func saveData():
	#Save total hearts
	sM.state.sceneIndex["HeartCount"] = healthNode.get_child_count()


