## Node for health
class_name Health
extends Node

var current_health : float
@export var parent : Node = owner

## Emitted when [method receive_damage] is called.The [param amount] is final damage, after
## the mitigation and susceptence were calculated.
signal damaged(amount, final_health)

## Emitted when [method receive_damage] is called. The [param amount] is raw damage, before
## the mitigation and susceptence were calculated.
signal raw_damaged(amount)

## Emitted when [method receive_healing] is called.
signal healed(amount, final_health)

## Emitted when [method receive_damage] is called. The [param amount] is raw healing, before
## the mitigation and susceptence were calculated.
signal raw_healed(amount)

## Emitted when [method change_health] is called.
signal health_changed(final_health, amount)

signal death()

func _ready() -> void:
	current_health = parent.parameters.max_health

func change_health(amount):
	current_health += amount
	current_health = clamp(current_health, 0, parent.parameters.max_health)
	health_changed.emit(current_health, amount)
	
	if current_health <= 0:
		death.emit()

func receive_damage(amount : float,\
resistance : float = parent.parameters.defense,\
susceptibility : float = parent.parameters.damage_susceptibility):
	var mitigated_damage = amount / ( 1 + ( max(0, resistance) / 100 ) )
	var amplified_damage = mitigated_damage + mitigated_damage * ( max(0, susceptibility) / 100 )
	var total_damage = amplified_damage
	change_health(-total_damage)
	
	damaged.emit(total_damage, current_health)
	raw_damaged.emit(amount)

func receive_healing(amount : float,\
resistance : float = parent.parameters.healing_resistance,\
susceptibility : float = parent.parameters.healing_susceptibility):
	var mitigated_healing = amount / ( 1 + ( max(0, resistance) / 100 ) )
	var amplified_healing = mitigated_healing + mitigated_healing * ( max(0, susceptibility) / 100 )
	var total_healing = amplified_healing
	change_health(total_healing)
	
	healed.emit(total_healing, current_health)
	raw_healed.emit(amount)
