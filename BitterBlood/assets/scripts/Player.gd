extends KinematicBody2D

class_name Player

#Movement Vars
export(int) var gravity = 200;
export(int) var walkSpeed = 80;
export(int) var jumpHeight = 100; 
export(int) var hp = 0;

export(Resource) var healthManager;

#Children & Preloaded
onready var screenSize = get_viewport_rect().size;
onready var sprite = $Sprite;

#Physics
var velocity = Vector2();
var snapVector = Vector2();
var floorNormal =  Vector2.UP;
var canSwim = false


func drop():
	position.y += 1;

func updateHealth(value):
	hp = value;

func getDirection() -> int:
	var spd = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))

	#Animate
	if spd == 1:
		sprite.flip_h = true;
	elif spd == -1:
		sprite.flip_h = false;

	return spd

func swim():
	canSwim = true

func leaveWater():
	canSwim = false
