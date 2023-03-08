class_name WaterSpring
extends Node2D

var velocity = 0;
var force = 0;
var height = 0;
var targetHeight = 0;

onready var collision = $Area2D/CollisionShape2D

var index = 0;
var splashFactor = 0.006;
var collided = null;
signal splash;

var timerMax = 15;
var timer = 0;

func updateWater(springConstant, damping):

	#Update Position
	height = position.y;
	
	var x = height - targetHeight;
	
	var loss = -damping * velocity;
	
	#Hooke's Law
	force = -springConstant * x + loss;
	
	velocity += force;
	
	position.y += velocity;
	
	if (timer > 0): 
		timer -= 1;
	else:
		if (collided != null):
			collided = null;
	
func initialize(xPosition, id):
	height = position.y;
	targetHeight = position.y;
	velocity = 0;
	position.x = xPosition;
	index = id;

func setCollisionWidth(value):
	var extents = collision.shape.get_extents();
	var newExtents = Vector2(value/2, extents.y);
	collision.shape.set_extents(newExtents);
	


func _on_Area2D_body_entered(body):
	if (body == collided):
		return;
	else:
		collided = body;
		timer = timerMax;
		body.takeDamage(1000)
		var speed = 1 + body.velocity.y * splashFactor;
		emit_signal("splash", index, speed);
