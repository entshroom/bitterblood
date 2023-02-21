extends Area2D

export(int) var wanderRadius
export(int) var discoveryRadius
export(int) var speed
export(NodePath) var targetPath

onready var timer = $Timer

var point
var target
var origin = global_position


enum state { WANDER, IDLE, CHASE }
var enemyState = state.WANDER

func _ready():
	#point = Vector2(randi() % int(wanderZone.x), randi() % int(wanderZone.y))
	target = get_node(targetPath)
	point = target.get_global_position()
 
func _process(delta):

	#Execute state
	match (enemyState):
		state.CHASE:
			point = target.get_global_position()
			global_position = global_position.move_toward(point, delta * speed * 2)

			#Exit
			if global_position.distance_to(target.global_position) > discoveryRadius:
				enemyState = state.WANDER
		
		state.WANDER:
			global_position = global_position.move_toward(point, delta * speed)
			
			if global_position.is_equal_approx(point):
				point.x = origin.x + randi() % wanderRadius
				point.y = origin.y + randi() % wanderRadius
				timer.start(float(2 + randi() % 8))
				enemyState = state.IDLE
			
			if global_position.distance_to(target.global_position) < discoveryRadius:
				enemyState = state.CHASE
			
			



func _on_Timer_timeout():
	if enemyState == state.IDLE:
		enemyState = state.WANDER


func _on_Ghost_body_entered(_body):
	get_tree().reload_current_scene()
