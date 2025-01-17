class_name Projectile
extends Area2D

@export var parameters : ProjectileParameters

func _physics_process(delta: float) -> void:
	global_position += transform.x * parameters.speed * delta


func _on_body_entered(body: Node2D) -> void:
	body.health.receive_damage(parameters.damage)
	queue_free()
