## Base class for all of the status effect logic.
@icon("res://addons/status effects sp1cyp3pp3r/icons/Effect.svg")
class_name Effect
extends Node

## Effect will apply properties from this array.
@export var properties_array : Array[EffectedProperty]
## The in-game object the [Effect] is affecting. Generally it's [Effect]'s parent.
@export var effected_game_object : Node = owner


func _ready():
	if not effected_game_object:
		# If target of an effect wasn't assigned, it will assign its parent
		effected_game_object = get_parent()
		owner = effected_game_object
	
	# Effect requries Parameters to be assigned.
	# Otherwise it's entirely skipped.
	if not effected_game_object.parameters:
		return
	
	apply_effects([])

func _exit_tree():
	discard_effects()

## Applies changes to the [param effected_game_object] variables from [param properties_array].
## If the [param applied_properties] is empty, will apply every property from [param properties_array].
## Otherwise will try to change listed in [Array][[StringName]]. 
func apply_effects(applied_properties : Array[StringName]) -> void:
	var is_apply_all_properties : bool = false
	if applied_properties.is_empty():
		is_apply_all_properties = true
	
	print("\n" + str(effected_game_object.name) + " " + str(get_instance_id()) + "# APPLYING EFFECTS # " + str(applied_properties) + "\n")
	
	for property : EffectedProperty in properties_array:
		var property_name : StringName = property.name
		if ( property_name in applied_properties ) or is_apply_all_properties:
			if property_name in effected_game_object.parameters:
				var initial_value : float = effected_game_object.parameters.get(property_name)
				var final_value : float
				var modificator : float = property.value
				
				print("\n" +  str(property_name))
				print("\n" + str(effected_game_object.name) + " " + str(get_instance_id()) + " - initial value " + str(initial_value))
				match property.mode:
					EffectedProperty.MODE.Addition:
						property.saved_value = modificator
						final_value = initial_value + modificator
					EffectedProperty.MODE.Percentage:
						var perc : float = (initial_value / 100) * modificator
						property.saved_value = perc
						final_value = initial_value + perc
				
				print(str(effected_game_object.name) + " " + str(get_instance_id()) + " - saved value " + str(property.saved_value))
				print(str(effected_game_object.name) + " " + str(get_instance_id()) + " - final value " + str(final_value))
				effected_game_object.parameters.set(property_name, final_value)

## Recovers the applied properties when effect exits the tree (it will exit the tree if forced to discard its effects).
func discard_effects() -> void:
	if not is_queued_for_deletion():
		queue_free()
		return
	
	print("\n" + str(effected_game_object.name) + " " + str(get_instance_id()) + "### DISCARDING EFFECTS ###" + "\n")
	
	for property : EffectedProperty in properties_array:
		var property_name = property.name
		if property_name in effected_game_object.parameters:
			var current_value = effected_game_object.parameters.get(property_name)
			
			print("\n"+str(property_name)+"\n")
			print(str(effected_game_object.name) + " " + str(get_instance_id()) + " - saved value (discard) " + str(property.saved_value))
			
			var final_value : float = current_value - property.saved_value
			effected_game_object.parameters.set(property_name, final_value)
			
			print(str(effected_game_object.name) + " " + str(get_instance_id()) + " - final value (discard) " + str(final_value))
	
	# Checks if EGO has other Effects.
	var do_reapply : bool = false
	for effect_child in effected_game_object.get_children():
		if effect_child is Effect and effect_child != self:
			# TODO
			# Probably need to check if it has properties with the same name
			do_reapply = true
	
	if do_reapply:
		reapply_effects()

## After [method discard_effect] it need to reapply other effects, as for percentage effects
## need to account for the new current value.
func reapply_effects() -> void:
	print("\n" + str(effected_game_object.name) + " " + str(get_instance_id()) + "### REAPPLYING EFFECTS ###" + "\n")
	
	var reapplied_effects : Array = []
	var reapplied_properties : Array[StringName] = []
	for property : EffectedProperty in properties_array:
		var reapplied_value : float = 0
		var property_name : String = property.name
		if property_name in effected_game_object.parameters and not property_name in reapplied_properties:
			if not property_name in reapplied_properties:
				reapplied_properties.append(property_name)
			var current_value = effected_game_object.parameters.get(property_name)
			for effect in effected_game_object.get_children():
				if effect is Effect and effect != self:
					var is_prompted : bool = false
					for eff_property : EffectedProperty in effect.properties_array:
						if eff_property.name == property_name:
							reapplied_value += eff_property.saved_value
							is_prompted = true
							
							print(str(property_name)+"\n")
							print(str(effected_game_object.name) + " " + str(get_instance_id()) + " - saved value (reapply) of " + str(effect.get_instance_id()) + " " + str(eff_property.saved_value))
							
					if is_prompted:
						if not reapplied_effects.has(effect):
							reapplied_effects.append(effect)
			
			if reapplied_value != 0:
				var final_value = current_value - reapplied_value
				effected_game_object.parameters.set(property_name, final_value)
				
				print(str(effected_game_object.name) + " " + str(get_instance_id()) + " - reapplied value " + str(reapplied_value))
				print(str(effected_game_object.name) + " " + str(get_instance_id()) + " - middle value (reapply) " + str(effected_game_object.parameters.get(property_name)))
				
			
	if not reapplied_effects.is_empty():
		for effect in reapplied_effects:
			if effect is Effect:
				effect.apply_effects(reapplied_properties)
		reapplied_effects.clear()
	
	# DEBUG
	for property in reapplied_properties:
		print(str(effected_game_object.name) + " " + str(get_instance_id()) + " - final value (reapply) " + str(effected_game_object.parameters.get(property)))
	
