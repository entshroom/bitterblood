extends Area2D

export(String) var abilityType

func _on_Ability_area_entered(area):
	match (abilityType):
		"Wall Jump":
			area.owner.hasWallJump = true
		"Kill Ghosts":
			area.owner.canKillGhosts = true
		"Brimstone Cannon":
			area.owner.brimstoneCannon = true
		"Dash":
			area.owner.hasDash = true
	
	queue_free()
