extends Node2D
## Node that serves as activatable or passive ability for [TowerGeneric].
class_name AbilityGeneric 

## Enum for storing different aim modes
enum AIM_MODE {
	First, ## Will target the most first enemy to the base, by checking its follow [param progress].
	Last, ## Will target the lastest enemy from the base, by checking its follow [param progress].
	Near, ## Will target the nearest enemy to the tower, by checking [method distance_to]
	Far, ## Will target the farest enemy to the tower, by checking [method distance_to]
	Strong, ## Will target the enemy with the most health [param WIP]
	Weak, ## Will target the enemy with the least health [param WIP]
	Random ## Will target enemy at random
	}
## Determines which enemy it shoots or otherwise targets:
@export var current_aim_mode : AIM_MODE = AIM_MODE.First
## Ability vision for [method current_target] and other shenanigans.
@export var view : ViewArea2D
## Ability cooldown timer.
@export var cd_timer : Timer
## Calculated [param wait_time] for cd_timer. Minimal time is 0.05, maximum time is 10.
## Takes in [param parameters.cool_down] to create an output: 10 is 1 s, 5 is 2s, 20 is 0.5.
var cd_time : float :
	get():
		var value = max(10 / max(parameters.cool_down, 1), 0.05)
		return value

signal target_assigned(target : Enemy)
signal no_target

## Used to generally decide if ability can be applied right now.
var prepared : bool = true

## Utilizes the ability. Either fire a projectile, send a chain lightning or single-time
## creates an aura, etc.
func apply() -> void:
	pass

func cooldown_end() -> void:
	prepared = true

## Returns [Enemy] from [member ViewArea2D.enemies_in_array] based on [member aim_mode].
func current_target(aim_mode : AIM_MODE = current_aim_mode) -> Enemy:
	var enemy_array = view.enemies_in_view
	if enemy_array.is_empty():
		no_target.emit()
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
	target_assigned.emit(enemy)
	return enemy

@export var parameters : AbilityParameters

func update_range(value : float) -> void:
	view.collision.shape.radius = value

func _ready() -> void:
	parameters.range_changed.connect(update_range)
	update_range(parameters.range)
