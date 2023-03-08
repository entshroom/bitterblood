extends Node2D

var droplet = preload("res://assets/prefabs/WaterDrop.tscn")

var offset
var startSpawn = false

onready var timer = $Timer

func _ready():
	offset = randi() % 200
	

func _process(_delta):
	if offset > 0:
		offset -= 1
	elif !startSpawn:
		startSpawn = true
		timer.start(2)



func _on_Timer_timeout():
	var drop = droplet.instance()
	self.add_child(drop)
