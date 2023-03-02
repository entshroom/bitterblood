extends Area2D

export(String) var message

onready var textBox = $TextPopup

var uiNode
var currentBox

func _ready():
	textBox.append_bbcode("[center]" + message + "[/center]")

func _on_TutorialStatue_area_entered(area):
	print("Collision Registered!")
	textBox.set_visible(true)
	


func _on_TutorialStatue_area_exited(area):
	textBox.set_visible(false)
