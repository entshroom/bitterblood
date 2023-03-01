extends Node

export(String) var groupName

func _ready():
	add_to_group(groupName)
