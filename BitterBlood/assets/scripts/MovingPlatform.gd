extends Node2D

const IDLE_DURATION = 1.0

var targetPosition = Vector2.ZERO

export(int) var unitsToMove = 5
export(int) var speed = 300
export(bool) var vertical

onready var platform = $Platform
onready var tween = $MoveTween

var follow = Vector2.ZERO

func _ready():
	if vertical:
		targetPosition = Vector2(0, 128 * -unitsToMove)
	else:
		targetPosition = Vector2(128 * unitsToMove, 0)
	
	_init_tween()


func _init_tween():
	var duration = targetPosition.length() / float(speed * 128)
	tween.interpolate_property(self, "follow", Vector2.ZERO, targetPosition, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "follow", targetPosition, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION * 2)
	tween.start()

func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)
	

