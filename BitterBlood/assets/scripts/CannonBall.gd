extends Area2D

export(int) var speed

var direction = -1

onready var cast = $RayCast2D

func _on_CannonBall_area_entered(area):
	if area.is_in_group("Enemies"):
		area.owner.takeDamage(5)
	

func _process(delta):
	if cast.is_colliding():
		var obj = cast.get_collider()
		if obj.is_in_group("Cracked Wall"):
			obj.queue_free()
		queue_free()
		
	position.x += speed * delta * direction
