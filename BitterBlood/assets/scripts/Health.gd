extends HBoxContainer

var heart = preload("res://assets/sprites/holyWater.png")
var heartEmpty = preload("res://assets/sprites/holyWaterDry.png")

func updateHealth(value):
	for i in get_child_count():
		if value > i:
			get_child(i).texture = heart
		else:
			get_child(i).texture = heartEmpty


func _on_Player_health_changed(new_hp):
	updateHealth(new_hp)
