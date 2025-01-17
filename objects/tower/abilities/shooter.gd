extends AbilityGeneric

var enemy : Enemy

func _process(delta):
	if enemy:
		$Gun.look_at(enemy.global_position)


func apply() -> void:
	if not enemy or not prepared:
		return
	
	$Gun.look_at(enemy.global_position)
	$Gun/Gunpoint.shoot(enemy)
	prepared = false
	
	cd_timer.start(cd_time)

func _on_view_area_2d_enemy_appeared(enemy: Enemy) -> void:
	current_target()




func _on_view_area_2d_enemies_clear() -> void:
	_on_no_target()


func _on_target_assigned(target: Enemy) -> void:
	enemy = target
	apply.call_deferred()


func _on_no_target() -> void:
	enemy = null


func _on_view_area_2d_enemy_exited(enemy: Enemy) -> void:
	current_target()


func _on_timer_timeout() -> void:
	current_target()
