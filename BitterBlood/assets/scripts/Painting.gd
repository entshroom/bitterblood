extends Area2D


onready var camera = $Camera2D

func _on_Painting_area_entered(_area):
	camera.current = true
