## Class for [Effect] to apply.
@icon("res://addons/status effects sp1cyp3pp3r/icons/EffectProperty.svg")
class_name EffectedProperty
extends Resource

enum MODE{
	Addition, ## Property will be added to the initial value.
	Percentage ## Property will be added as percentage from initial value to the property.
	}

@export var name : StringName ## Name of the property. Must be exactly the same as one in the [Parameters] of effected game object.
@export var value : float ## The amount of which property will change, depended on [param mode]
@export var mode : MODE ## Determines which way the property will be calculated:

## After assigning a change to the property. The amount changed will be assigned to this variable.
## It's used to recover the property after discarding its [Effect].
var saved_value : float = 0
