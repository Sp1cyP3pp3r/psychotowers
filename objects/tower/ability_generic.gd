extends Node2D
## Node that serves as activatable or passive ability for [TowerGeneric].
class_name AbilityGeneric

## Enum for storing different aim modes
enum AIM_MODE {
	First, ## Will target the most first enemy to the base, by checking its follow [param progress].
	Last, ## Will target the lastest enemy from the base, by checking its follow [param progress].
	Near, ## Will target the nearest enemy to the tower, by checking [method distance_to]
	Far, ## Will target the farest enemy to the tower, by checking [method distance_to]
	Strong, ## Will target the enemy with the most health
	Weak, ## Will target the enemy with the least health
	Random ## Will target enemy at random
	}
## Determines which enemy it shoots or otherwise targets:
@export var current_aim_mode : AIM_MODE = AIM_MODE.First
## Ability vision for [method current_target] and other shenanigans.
@onready var view : ViewArea2D = $ViewArea

## Utilizes the ability. Either fire a projectile, send a chain lightning or single-time
## creates an aura, etc.
func apply() -> void:
	pass

## Returns [Enemy] from [member ViewArea2D.enemies_in_array] based on [member aim_mode].
func current_target(aim_mode : AIM_MODE = current_aim_mode) -> Enemy:
	var enemy_array = view.enemies_in_view
	if enemy_array.is_empty():
		return
	var enemy : Enemy = enemy_array[0]
	
	match aim_mode:
		AIM_MODE.First:
			for _enemy in enemy_array:
				if _enemy.progress >= enemy.progress:
					enemy = _enemy
		AIM_MODE.Last:
			for _enemy in enemy_array:
				if _enemy.progress <= enemy.progress:
					enemy = _enemy
		AIM_MODE.Near:
			for _enemy in enemy_array:
				if _enemy.global_position.distance_to(global_position) <=\
				enemy.global_position.distance_to(global_position):
					enemy = _enemy
		AIM_MODE.Far:
			for _enemy in enemy_array:
				if _enemy.global_position.distance_to(global_position) >=\
				enemy.global_position.distance_to(global_position):
					enemy = _enemy
		AIM_MODE.Strong:
			pass
		AIM_MODE.Weak:
			pass
		AIM_MODE.Random:
			enemy = enemy_array.pick_random()
	return enemy
