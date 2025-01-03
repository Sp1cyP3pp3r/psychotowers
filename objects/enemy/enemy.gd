extends CharacterBody2D
class_name Enemy

var progress : float = owner.progress :
	get:
		return owner.progress
	set(val):
		owner.progress = val
		progress = val

func _physics_process(delta: float) -> void:
	owner.progress += delta * 30
