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
export(int) var knockbackForce

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
onready var knockbackTimer = $Timer
onready var dashTimer = $DashTimer

var cannonBall = preload("res://assets/prefabs/CannonBall.tscn")

#Utility
var hp
var invincible = false

#Data Management
var sM
var hasKey = false

#Physics
var velocity = Vector2();
var snapVector = Vector2();
var floorNormal =  Vector2.UP;
var canSwim = false
var knockback = false

#Trackers
var direction = 1
var d = 1

var doubleTap = false
var tapCountLeft = 0
var tapCountRight = 0
var maxTime = 0.2
var dtapTime = 0

#Cooldowns
var canAirAttack = true
var canInteract = true
var canMove = true
var canAttack = true
var canJump = true
var canDash = true

export(bool) var hasWallJump = false
export(bool) var hasDash = false
export(bool) var canKillGhosts = false
export(bool) var brimstoneCannon = false

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

func takeDamage(value, apply_knockback = true):
	if !knockback && !invincible:
		hp -= value
		if apply_knockback:
			knockback = true
		emit_signal("health_changed", hp)

		if hp <= 0:
			if sM.state.sceneIndex.has("RespawnPosition"):
				setHealth()
				emit_signal("bloodlust_gained", 100)
				get_tree().call_group("Persistent","saveData")
				get_tree().call_group("Persistent","loadData")
				position = sM.state.sceneIndex["RespawnPosition"]
			else:
				var _error = get_tree().reload_current_scene()
		


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
		
	#Interactables
	if Input.is_action_just_pressed("interact") && canInteract:
		get_tree().call_group("Interactable", "checkInteract", self)

	countDoubleTap(_delta)


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
	
	#Unlocks
	sM.state.sceneIndex["WallJumpUnlocked"] = hasWallJump
	sM.state.sceneIndex["DashUnlocked"] = hasDash
	sM.state.sceneIndex["CanKillGhosts"] = canKillGhosts
	sM.state.sceneIndex["BrimstoneCannon"] = brimstoneCannon

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
	
	#Unlocks
	if sM.state.sceneIndex.has("WallJumpUnlocked"):
		hasWallJump = sM.state.sceneIndex["WallJumpUnlocked"]
	
	if sM.state.sceneIndex.has("CanKillGhosts"):
		canKillGhosts = sM.state.sceneIndex["CanKillGhosts"]

	if sM.state.sceneIndex.has("BrimstoneCannon"):
		brimstoneCannon = sM.state.sceneIndex["BrimstoneCannon"]
		
	if sM.state.sceneIndex.has("DashUnlocked"):
		hasDash = sM.state.sceneIndex["DashUnlocked"]


func _on_Hitbox_area_entered(area):
	#KILL ALL WHO OPPOSE US
	if area.is_in_group("Enemies") && !area.is_in_group("Spikes"):
		area.owner.takeDamage(1)
		
		if area.owner.hp <= 0 && area.owner.bloodlust:
			setHealth(hp + 1)
		else:
			emit_signal("bloodlust_gained", 10)


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Enemies"):
		if !area.owner.is_in_group("Ghosts") || area.owner.is_in_group("Ghosts") && area.owner.hostile:
			takeDamage(1)
		emit_signal("bloodlust_gained", 5)


func _on_Hurtbox_body_entered(body):
	if body.is_in_group("HiddenWall"):
		body.set_modulate(Color(1,1,1,0.5))
	if body.is_in_group("Spikes"):
		takeDamage(1)
		print("Spikes")
		emit_signal("bloodlust_gained", 5)


func _on_Hurtbox_body_exited(body):
	if body.is_in_group("HiddenWall"):
		body.set_modulate(Color(1,1,1,1))

func countDoubleTap(delta):
	
	if dtapTime < maxTime:
		dtapTime += 1 * delta
		
		if Input.is_action_just_pressed("left"):
			dtapTime = 0
			tapCountLeft += 1

		if Input.is_action_just_pressed("right"):
			dtapTime = 0
			tapCountRight += 1
		
		if tapCountLeft > 0 && tapCountRight > 0:
			dtapTime = 0
			tapCountLeft = 0
			tapCountRight = 0
		
		if tapCountLeft >= 2 || tapCountRight >= 2:
			doubleTap = true
			tapCountLeft = 0
			tapCountRight = 0
	else:
		doubleTap = false
		dtapTime = 0
		tapCountLeft = 0
		tapCountRight = 0
#var doubleTap = false
#var tapCount = 0
#var maxTime = 5
#var dtapTime = 0


func _on_DashTimer_timeout():
	canDash = true
