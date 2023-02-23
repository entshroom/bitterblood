extends KinematicBody2D

class_name Player

#Signals
signal health_changed(new_hp) 

#Movement Vars
export(int) var gravity = 200;
export(int) var walkSpeed = 80;
export(float) var friction = 0.1;
export(float) var acceleration = 0.5;
export(int) var jumpHeight = 100; 
export(float) var jumpCancel = 0.7;
export(float) var slopeThreshold = 0.25;

#Health
export(int) var hp = 5;

export(Resource) var healthManager;

#Children & Preloaded
onready var screenSize = get_viewport_rect().size;
onready var sprite = $Sprite;
onready var cast = $Wallchecker;

#Physics
var velocity = Vector2();
var snapVector = Vector2();
var floorNormal =  Vector2.UP;
var canSwim = false

#Trackers
var direction = 1
var d = 1


func drop():
	position.y += 1;
	
func isNearWall():
	return cast.is_colliding()

func takeDamage(value):
	hp -= value
	
	if hp <= 0:
		get_tree().reload_current_scene() 
		
	emit_signal("health_changed", hp)

func getDirection(animate := true) -> int:
	var spd = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))

	#Animate and update casters
	if animate:
		if spd == 1:
			sprite.flip_h = true;
			cast.cast_to.x = 30
		elif spd == -1:
			sprite.flip_h = false;
			cast.cast_to.x = -30

	return spd

func swim():
	canSwim = true

func leaveWater():
	canSwim = false

func _process(_delta):
	d = getDirection()
	if d != 0:
		direction = d
	pass
