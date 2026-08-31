class_name AbInputPushKeyValue
extends Node

signal on_analog_value_relayed(key_name:String, analog_value:float)
signal on_boolean_value_relayed(key_name:String, boolean_value:bool)
signal on_device_event_value_relayed(key_name:String, trigger_value:String)



func set_analog_value(key_name:String, analog_value:float):
	_on_analog_value_relayed(key_name, analog_value)
	on_analog_value_relayed.emit(key_name, analog_value)
	
func set_boolean_value(key_name:String, boolean_value:bool):
	_on_boolean_value_relayed(key_name, boolean_value)
	on_boolean_value_relayed.emit(key_name, boolean_value)


## To be overridden by the inheriting class
func _on_analog_value_relayed(key_name:String, analog_value:float):
	pass

## To be overridden by the inheriting class
func _on_boolean_value_relayed(key_name:String, boolean_value:bool):
	pass	
	
## To be overridden by the inheriting class
func _on_device_event_relayed(input_name:String, trigger_value:String):
	pass
		
func trigger_event_with_input_name(input_name:String, trigger_value:String):
	_on_device_event_relayed(input_name, trigger_value)	
	on_device_event_value_relayed.emit(input_name, trigger_value)
