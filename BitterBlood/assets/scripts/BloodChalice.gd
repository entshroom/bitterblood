extends Area2D

var playerNode
var interacted = false

export(String) var spell = ""

var ability = preload("res://assets/prefabs/Ability.tscn")

func _ready():
	add_to_group("Interactable")

func checkInteract(player):
	
	if player.position.distance_to(position) < 400 && !interacted:
		var a = ability.instance()
		a.position.y -= 300
		a.abilityType = spell
		self.add_child(a)
		interacted = true
