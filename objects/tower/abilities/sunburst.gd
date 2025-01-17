extends AbilityGeneric

func _ready() -> void:
	EB.connect("enemy_appeared", assign_enemy)

var target_enemy

func assign_enemy(enemy):
	target_enemy = enemy
	apply()
	target_enemy = null

func apply() -> void:
	if prepared and target_enemy:
		target_enemy.health.receive_damage(parameters.power * 2)
		prepared = false
		cd_timer.start(cd_time)
