extends KinematicBody2D

onready var castleft = $left
onready var castright = $right

export(int) var gravity = 100
export(int) var speed = 100

var velocity = Vector2.ZERO
var direction = 0

func _physics_process(delta):
	
	if !is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = (direction * speed)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if castleft.is_colliding():
		direction = -1
	elif castright.is_colliding():
		direction = 1
	else:
		direction = 0
