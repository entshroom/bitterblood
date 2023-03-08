extends Area2D

var canvasAnimation

export(String) var animation

func _ready():
	canvasAnimation = get_node("/root/" + owner.name + "/Environment/CanvasModulate/AnimationPlayer")
func _on_LightTransition_area_entered(_area):
	canvasAnimation.play(animation)
