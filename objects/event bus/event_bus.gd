## Handles signal rerooting. This is an Autoload.
class_name EventBus
extends Node


signal enemy_appeared(enemy)

#func event(signal_name : String):
	#add_user_signal(signal_name, [])
	#emit_signal(signal_name)
