class_name AbUiInputLineEditChanged
extends AbUiInputAbstractAnalogBooleanSource

@export var _line_edit:LineEdit
func get_key_name()->String:
	if _line_edit:
		return _line_edit.text
	return ""

	
func notify_analog_value_to_relayed(analog_value:float):
	notify_analog_value_to_relayed_with_key_name(get_key_name(), analog_value)

func notify_boolean_value_to_relayed(boolean_value:bool):
	notify_boolean_value_to_relayed_with_key_name(get_key_name(), boolean_value)
