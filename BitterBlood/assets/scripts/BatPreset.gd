extends Node2D


export(int) var Direction = 1
export(int) var Speed = 300

onready var bat = $Bat

func _ready():
	bat.direction = Direction
	bat.speed = Speed
