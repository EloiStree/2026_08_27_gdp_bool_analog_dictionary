class_name AbUiInputKeyChanged
extends AbUiInputAbstractAnalogBooleanSource

@export var _input_key_name:String
func get_key_name()->String:
	return _input_key_name

	


func notify_analog_value_to_relayed(analog_value:float):
	notify_analog_value_to_relayed_with_key_name(get_key_name(), analog_value)

func notify_boolean_value_to_relayed(boolean_value:bool):
	notify_boolean_value_to_relayed_with_key_name(get_key_name(), boolean_value)
