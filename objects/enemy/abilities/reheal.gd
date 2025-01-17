extends EnemyAbilityGeneric

func get_damage(damage):
	taken_damage += damage
	if $Timer.is_stopped():
		$Timer.start()

var taken_damage : float

func apply():
	var healing = taken_damage / 2
	affected_enemy.health.receive_healing(healing)
	taken_damage = 0


func _on_timer_timeout() -> void:
	apply()
