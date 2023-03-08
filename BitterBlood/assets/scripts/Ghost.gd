extends Node2D

export(bool) var hostile = true
export(int) var wanderRadius
export(int) var discoveryRadius
export(int) var speed
export(int) var hp = 4
onready var timer = $Ghost/Timer

var bloodlust = false
var point
var target
var origin


enum state { WANDER, IDLE, CHASE }
var enemyState = state.WANDER

func _ready():
	origin = position
	#point = Vector2(randi() % int(wanderZone.x), randi() % int(wanderZone.y))
	target = get_node("/root/" + owner.name + "/Player")
	point = target.position
	add_to_group("EnemyLogic")
	add_to_group("Ghosts")
	$Ghost.add_to_group("Enemies")

func _process(delta):

	#Execute state
	match (enemyState):
		state.CHASE:
			point = target.position
			position = position.move_toward(point, delta * speed * 2)

			#Exit
			if position.distance_to(target.position) > discoveryRadius:
				enemyState = state.WANDER
		
		state.WANDER:
			position = position.move_toward(point, delta * speed)
			
			if position.is_equal_approx(point):
				point.x = origin.x + randi() % wanderRadius
				point.y = origin.y + randi() % wanderRadius
				timer.start(float(2 + randi() % 8))
				enemyState = state.IDLE
			
			if position.distance_to(target.position) < discoveryRadius && hostile:
				enemyState = state.CHASE
			
func takeDamage(amount):
	if target.canKillGhosts:
		hp -= amount
		timer.start(0.5)
		enemyState = state.IDLE
	
	if hp <= 0:
		queue_free()
		
func toggleBloodlust():
	match (bloodlust):
		true:
			bloodlust = false
		false:
			bloodlust = true


func _on_Timer_timeout():
	if enemyState == state.IDLE:
		enemyState = state.WANDER

