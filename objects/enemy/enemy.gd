extends CharacterBody2D
class_name Enemy

@onready var progress : float = owner.progress :
	get:
		return owner.progress
	set(val):
		progress = val
@onready var progress_to : float = progress

@export var parameters : EnemyParameters
@export var health : Health

signal appeared(enemy)

func _ready() -> void:
	appeared.connect(EB.enemy_appeared.emit)
	appeared.emit(self)
	

func _physics_process(delta: float) -> void:
	progress_to += parameters.speed * delta
	owner.progress = lerp(progress, progress_to, delta * 15)
	$Node/ProgressBar.max_value = parameters.max_health
