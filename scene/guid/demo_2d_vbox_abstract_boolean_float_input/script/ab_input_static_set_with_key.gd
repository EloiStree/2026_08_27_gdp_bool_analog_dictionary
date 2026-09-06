class_name AbInputStaticSetWithKey
extends AbInputPushKeyValue

@export var _input_name_for_primitive:String
func trigger_event_with_inspector_input_name(trigger_value:String):
	AbInputDictionary.get_singleton().trigger_event_from_device_name(_input_name_for_primitive, trigger_value)
	
func set_analog_value_with_inspector_input_name(analog_value:float):
	AbInputDictionary.get_singleton().set_analog_from_device_name(_input_name_for_primitive, analog_value)
	
func set_boolean_value_with_inspector_input_name(boolean_value:bool):
	AbInputDictionary.get_singleton().set_boolean_from_device_name(_input_name_for_primitive, boolean_value)

func _on_analog_value_relayed(input_name:String, analog_value:float):
	AbInputDictionary.get_singleton().set_analog_from_device_name(input_name, analog_value)

func _on_boolean_value_relayed(input_name:String, boolean_value:bool):
	AbInputDictionary.get_singleton().set_boolean_from_device_name(input_name, boolean_value)

func _on_device_event_relayed(input_name:String, trigger_value:String):
	AbInputDictionary.get_singleton().trigger_event_from_device_name(input_name, trigger_value)
