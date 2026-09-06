## Instead of using dictionary all the time.
## When you use a small amount of input sources, Dictionary are an antipattern.
## So any value that you set here use local reference to set the value.
class_name AbInputStaticSetWithLocalRefList
extends AbInputPushKeyValue

var _analog_list_ref:Array[AbInputResourceAnalogValue] = []
var _boolean_list_ref:Array[AbInputResourceBooleanValue] = []

func find_in_analog_list_ref_by_name_id(name_id:String) -> AbInputResourceAnalogValue:
	for analog in _analog_list_ref:
		if analog.get_analog_name_id() == name_id:
			return analog
	return null
func find_in_boolean_list_ref_by_name_id(name_id:String) -> AbInputResourceBooleanValue:
	for boolean in _boolean_list_ref:
		if boolean.get_boolean_name_id() == name_id:
			return boolean
	return null

func _on_analog_value_relayed(input_name:String, analog_value:float):
	var analog = find_in_analog_list_ref_by_name_id(input_name)
	if not analog:
		analog = AbInputDictionary.get_singleton().get_analog_resource_reference_from_device_name(input_name)
		_analog_list_ref.append(analog)
	analog.set_analog_value(analog_value)
	
func _on_boolean_value_relayed(input_name:String, boolean_value:bool):
	var boolean = find_in_boolean_list_ref_by_name_id(input_name)
	if not boolean:
		boolean = AbInputDictionary.get_singleton().get_boolean_resource_reference_from_device_name(input_name)
		_boolean_list_ref.append(boolean)
	boolean.set_boolean_value(boolean_value)

func _on_device_event_relayed(input_name:String, trigger_value:String):
	AbInputDictionary.get_singleton().trigger_event_from_device_name(input_name, trigger_value)
