extends KinematicBody2D

var interacting = false
var openDialogue
var playerNode

export(bool) var keyGiver = false

export var dialoguePath = ""

var dialogue = preload("res://assets/prefabs/Dialogue.tscn")
var key = preload("res://assets/prefabs/KeyPickup.tscn")

func _ready():
	add_to_group("Interactable")

func checkInteract(player):
	
	if player.position.distance_to(position) < 400:
		player.canInteract = false
		player.canMove = false
		player.canJump = false
		player.canAttack = false
		playerNode = player
		interactFunction(false)
	

func interactFunction(state) -> void:
	if state:
		interacting = false
		playerNode.canInteract = true
		playerNode.canMove = true
		playerNode.canJump = true
		playerNode.canAttack = true
		
		if keyGiver:
			var k = key.instance()
			owner.get_node("Environment").add_child(k)
			k.position = position
			k.position.x += 200
			keyGiver = false
			
	else:
		interacting = true
		openDialogue = dialogue.instance()
		openDialogue.dialoguePath = dialoguePath
		openDialogue.creator = self
		get_node("/root/" + owner.name + "/UI").add_child(openDialogue)
