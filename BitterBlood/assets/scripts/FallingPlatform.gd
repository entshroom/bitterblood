extends StaticBody2D

onready var animplayer = $AnimationPlayer

func _on_Area2D_area_entered(area):
	animplayer.play("Fall")
