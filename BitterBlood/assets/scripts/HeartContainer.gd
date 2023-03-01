extends Area2D

export(int) var heartCount

signal upgradeHealth

var health

func _ready():
	health = get_node("/root/" + owner.name + "/UI/Control")
	print(connect("upgradeHealth",health,"addHearts"))
	

func _on_HeartContainer_body_entered(body):
	emit_signal("upgradeHealth", heartCount)
	body.hpMax += heartCount
	body.setHealth()
	queue_free()
