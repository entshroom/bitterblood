extends KinematicBody2D

#Export Variables
export(int) var speed = 20
export(int) var direction = 1
export(int) var hp = 3

#Onready Variables
onready var detectionCollider = $Detectionbox/Collider
onready var hitbox = $Hitbox
onready var timer = $Timer


#Variables
var bloodlust = false
var target
var targetLocation
var origin
var defaultDirection

#State Machine
enum state { IDLE, DIVE, FLY, HIDE }
var enemyState = state.IDLE

func _ready():
	
	add_to_group("EnemyLogic")
	hitbox.add_to_group("Enemies")
	
	#Determine Origin
	origin = position

	#Find Target
	target = get_node("/root/" + owner.name + "/Player")
	targetLocation = target.position
	
	#Set Direction
	detectionCollider.position.x *= direction
	speed *= direction
	defaultDirection = direction
	
func _process(delta):
	
	#test.global_position = origin

	#Execute States
	match (enemyState):

		state.DIVE:
			
			#Update Player Position
			targetLocation = target.position

			#Move down until level with player
			move_and_slide(Vector2(0, 200), Vector2.UP)

			if position.y > targetLocation.y:
				enemyState = state.FLY
		
		state.FLY:
			#Move
			move_and_slide(Vector2(speed, 0), Vector2.UP)
			
			#Change Direction
			if is_on_wall():
				direction *= -1
				speed *= direction


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
			
func _on_Detectionbox_body_entered(body):
	if enemyState != state.FLY:
		enemyState = state.DIVE


func _on_VisibilityNotifier2D_screen_exited():
	if enemyState == state.FLY:
		position = origin
		enemyState = state.HIDE
		direction = defaultDirection
		speed *= defaultDirection
		timer.start(5)
		set_visible(false)

func _on_VisibilityNotifier2D_screen_entered():
	if enemyState == state.HIDE && timer.is_stopped():
		set_visible(true)
		enemyState = state.IDLE

