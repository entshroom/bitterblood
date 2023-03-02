extends KinematicBody2D

class_name Player

#Signals
signal health_changed(new_hp) 
signal bloodlust_gained(amount)

#Movement Vars
export(int) var gravity = 200;
export(int) var walkSpeed = 80;
export(float) var friction = 0.1;
export(float) var acceleration = 0.5;
export(int) var jumpHeight = 100; 
export(float) var jumpCancel = 0.7;
export(float) var slopeThreshold = 0.25;

#Health
export(int) var hpMax = 5;

#Children & Preloaded
onready var screenSize = get_viewport_rect().size;
onready var sprite = $Sprite;
onready var anim = $AnimationPlayer;
onready var rapier = $Sprite/Rapier/Hitbox
onready var stateMachine = $StateMachine
onready var cast = $Wallchecker;
onready var cast2 = $Wallchecker2;
onready var cast3 = $Wallchecker3;

#Utility
var hp

#Data Management
var sM

#Physics
var velocity = Vector2();
var snapVector = Vector2();
var floorNormal =  Vector2.UP;
var canSwim = false

#Trackers
var direction = 1
var d = 1

#Cooldowns
var canAirAttack = true

func _ready():
	sM = owner
	add_to_group("Persistent")
	add_to_group("Globals")
	
	hp = hpMax

func drop():
	position.y += 5;
	
func isNearWall():
	if cast.is_colliding() && cast2.is_colliding() && cast3.is_colliding():
		return true
	else:
		return false

func setHealth(value = hpMax):
	hp = value
	
	if hp > hpMax:
		hp = hpMax

	emit_signal("health_changed", hp)

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
			sprite.scale.x = 0.6;
			sprite.offset.x = 30
			
			#Wall Checkers
			cast.cast_to.x = 30
			cast2.cast_to.x = 30
			cast3.cast_to.x = 30
		elif spd == -1:
			sprite.scale.x = -0.6;
			sprite.offset.x = 50
			
			#Wall Checkers
			cast.cast_to.x = -70
			cast2.cast_to.x = -70
			cast3.cast_to.x = -70

	return spd

func swim():
	canSwim = true

func leaveWater():
	canSwim = false

func _process(_delta):
	d = getDirection()
	if d != 0:
		direction = d


func _physics_process(_delta):
	if !canAirAttack && is_on_floor() || is_on_wall():
		canAirAttack = true

func saveData():
	
	#Positional Data
	#var subName = sM.sceneName
	#sM.state.sceneIndex[subName]["PlayerPosition"] = position
	
	#Health
	sM.state.sceneIndex["MaxHP"] = hpMax
	sM.state.sceneIndex["HP"] = hp
	print("HP Saved: " + str(sM.state.sceneIndex["HP"]))

func loadData():

	#Positional Data
	if sM.state.sceneIndex.has("NextPlayerPosition"):
		position = sM.state.sceneIndex["NextPlayerPosition"]
	
	#HP
	if sM.state.sceneIndex.has("HP"):
		hp = sM.state.sceneIndex["HP"]

	if sM.state.sceneIndex.has("MaxHP"):
		hpMax = sM.state.sceneIndex["MaxHP"]
		print("HP Max" + str(hpMax))


func _on_Hitbox_area_entered(area):
	#KILL ALL WHO OPPOSE US
	if area.is_in_group("Enemies"):
		area.owner.takeDamage(1)
		
		if area.owner.hp <= 0 && area.owner.bloodlust:
			setHealth(hp + 1)
		else:
			emit_signal("bloodlust_gained", 10)


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Enemies"):
		takeDamage(1)
		emit_signal("bloodlust_gained", 5)


func _on_Hurtbox_body_entered(body):
	if body.is_in_group("Spikes"):
		takeDamage(1)
		print("Spikes")
		emit_signal("bloodlust_gained", 5)
