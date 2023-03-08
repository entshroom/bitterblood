extends KinematicBody2D

export(int) var speed
export(int) var gravity = 100

export(int) var hp

export(bool) var keyOwner = false

onready var cast = $Floorchecker
onready var sprite = $Sprite
onready var timer = $Timer
onready var player = get_node("/root/" + owner.name + "/Player")

var key = preload("res://assets/prefabs/KeyPickup.tscn")

var direction
var velocity = Vector2()
var bloodlust = false

var knockback = false
var canReset = false

func _ready():
	#Add to enemy group
	add_to_group("EnemyLogic")
	add_to_group("Persistent")
	add_to_group("Globals")

	$Hitbox.add_to_group("Enemies")

func _physics_process(_delta):
	
	velocity.y += gravity
	
	if !knockback:
		velocity.x = speed
	elif canReset && is_on_floor():
		knockback = false
		canReset = false

	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_wall() || is_on_floor() && !cast.is_colliding():
		flip()

func flip():
	cast.position.x *= -1
	sprite.scale.x *= -1
	speed *= -1

func takeDamage(amount):
	hp -= amount
	if hp <= 0:
		if keyOwner:
			var k = key.instance()
			owner.get_node("Environment").add_child(k)
			k.position = position
			keyOwner = false
			#Save Data
			saveData()
		queue_free()
	
	#knockback
	knockback = true
	timer.start(0.3)
	if player.position.x < position.x:
		velocity.x += 800
	else:
		velocity.x += -800
	
	velocity.y = -1200

func toggleBloodlust():
	match (bloodlust):
		true:
			bloodlust = false
		false:
			bloodlust = true
			


func _on_Timer_timeout():
	canReset = true

func saveData():
	owner.state.sceneIndex[owner.name][name+"KeyOwner"] = keyOwner
	
func loadData():
	if owner.state.sceneIndex[owner.name].has(name+"KeyOwner"):
		keyOwner = owner.state.sceneIndex[owner.name][name+"KeyOwner"]
