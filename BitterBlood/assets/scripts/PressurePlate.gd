extends Area2D

var active = false

signal plateDown

func _on_PressurePlate_body_entered(_body):
	emit_signal("plateDown", true)
	position.y += 80


func _on_PressurePlate_body_exited(_body):
	emit_signal("plateDown", false)
	position.y -= 80
