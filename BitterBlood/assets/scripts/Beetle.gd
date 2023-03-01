extends KinematicBody2D

export(int) var speed
export(int) var hp

onready var cast = $Floorchecker
onready var sprite = $Sprite

var direction
var velocity = Vector2(1, 0)
var bloodlust = false

func _ready():
	#Add to enemy group
	add_to_group("EnemyLogic")
	$Hitbox.add_to_group("Enemies")

func _physics_process(_delta):
	velocity = move_and_slide(Vector2(1,0) * speed, Vector2.UP)
	
	if is_on_wall() || !cast.is_colliding():
		flip()

func flip():
	cast.position.x *= -1
	sprite.scale.x *= -1
	speed *= -1

func takeDamage(amount):
	hp -= amount
	if hp <= 0:
		queue_free()

func toggleBloodlust():
	match (bloodlust):
		true:
			bloodlust = false
		false:
			bloodlust = true
			
