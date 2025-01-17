class_name EnemyAbilityGeneric
extends Node2D

@export var affected_enemy : Enemy
@export var parameters : EnemyAbilityParameters
## Ability cooldown timer.
@export var cd_timer : Timer
## Calculated [param wait_time] for cd_timer. Minimal time is 0.05, maximum time is 10.
## Takes in [param parameters.cool_down] to create an output: 10 is 1 s, 5 is 2s, 20 is 0.5.
var cd_time : float :
	get():
		var value = max(10 / max(parameters.cool_down, 1), 0.05)
		return value

## Used to generally decide if ability can be applied right now.
var prepared : bool = true

## Utilizes the ability. Either fire a projectile, send a chain lightning or single-time
## creates an aura, etc.
func apply() -> void:
	pass

func cooldown_end() -> void:
	prepared = true
