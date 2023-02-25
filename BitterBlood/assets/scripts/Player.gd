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
onready var anim = $AnimationPlayer;
onready var rapier = $Sprite/Rapier/Hitbox

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

func _ready():
	sM = owner
	add_to_group("Persistent")
	add_to_group("Globals")

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
			sprite.scale.x = 0.1;
			cast.cast_to.x = 30
		elif spd == -1:
			sprite.scale.x = -0.1;
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

func saveData():
	
	#Positional Data
	var subName = sM.sceneName
	sM.state.sceneIndex[subName]["PlayerPosition"] = position
	
	#Health
	sM.state.sceneIndex["HP"] = hp
	print("HP Saved: " + str(sM.state.sceneIndex["HP"]))

func loadData():

	#Positional Data
	if sM.state.sceneIndex[sM.sceneName].has("PlayerPosition"):
		position = sM.state.sceneIndex[sM.sceneName]["PlayerPosition"]
	
	#HP
	if sM.state.sceneIndex.has("HP"):
		hp = sM.state.sceneIndex["HP"]


func _on_Hitbox_area_entered(area):
	#KILL ALL WHO OPPOSE US
	if area.is_in_group("Enemies"):
		area.owner.takeDamage(1)
