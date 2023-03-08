extends Area2D

func _ready():
	add_to_group("Spikes")
	add_to_group("Enemies")

func _process(_delta):
	position.y += 40


func _on_WaterDrop_body_entered(body):
	if !body.is_in_group("Persistent"):
		queue_free()
