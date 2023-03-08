extends AnimationPlayer

func _ready():
	play("Retract")
	self.get_parent().add_to_group("Enemies")
	self.get_parent().add_to_group("Spikes")
