extends StatusEffect

@export var amount : float = 10
@export var duration : float = 3

func _activate(hitter) -> void:
	parent = get_parent()
	amount = parent.speed / 100 * amount
	parent.speed -= amount
	
	create_timer(duration)

func create_timer(time) -> void:
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.autostart = true
	
	parent.add_child(timer)
	timer.timeout.connect(discard)
	timer.timeout.connect(timer.queue_free)

func discard() -> void:
	parent.speed += amount
	
