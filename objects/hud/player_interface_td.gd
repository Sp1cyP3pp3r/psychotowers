extends CanvasLayer

@onready var anim : AnimationPlayer = $AnimationPlayer

func show_hide_inventory(show : bool):
	match show:
		true:
			anim.play("slide_in")
		false:
			anim.play("slide_out")
