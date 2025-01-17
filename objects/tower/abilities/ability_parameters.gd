class_name AbilityParameters
extends Parameters

signal range_changed(value)

@export var range : float : ## Determines ability's [ViewArea2D] range.
	set(val):
		range = val
		range_changed.emit(range)
@export var cool_down : float
@export var power : float
