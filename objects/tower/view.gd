extends Area2D
## View cones and vision zones for determining which enemies are inside.
class_name ViewArea2D 

## Determines if this viewcone can see enemies in group "Hiders".
@export var seeker : bool = false
var enemies_in_view : Array[Enemy] = [] ## [Array] containing enemies currently inside the view area.
@onready var ray : RayCast2D = $NoObstacle ## [RayCast2D] for determining if enemy is obstracted by wall. Used in [method is_enemy_seen].
@onready var collision : CollisionShape2D = $CollisionShape2D  ## Shape for the area.

## This signal is emmited when no enemies left in the [param enemies_in_view] array.
signal enemies_clear
## This signal is emmited when at least one enemy entered the [param enemies_in_view] array.
## It fires the enemy entered the viewcone that way.
signal enemy_appeared(enemy : Enemy)
## It fires the enemy exited the viewcone that way.
signal enemy_exited(enemy : Enemy)


## Adds an [param Enemy] into the [param enemies_in_view] array.
func add_enemy(enemy : Enemy) -> void:
	if enemy not in enemies_in_view:
		enemies_in_view.append(enemy)
		enemy_appeared.emit(enemy)

## Removes an [param Enemy] from the [param enemies_in_view] array.
func remove_enemy(enemy : Enemy) -> void:
	if enemy in enemies_in_view:
		enemies_in_view.erase(enemy)
		enemy_exited.emit(enemy)
	
	if enemies_in_view.is_empty():
		enemies_clear.emit()

## Returns [param false] if [param enemy] is obscured by wall or if it is in group [param "Hiders"].
## Otherwise [param true].
func is_enemy_seen(enemy : Enemy) -> bool:
	if enemy.is_in_group(&"Hiders") and not seeker:
		return false
	
	var enemy_pos = enemy.global_position
	var direction = enemy_pos.direction_to(global_position)
	var distance = enemy_pos.distance_to(global_position)
	ray.target_position = direction * distance
	
	if ray.is_colliding():
		# enemy is obscured by wall
		return false
	return true
