class_name AbUiInputAbstractAnalogBooleanSource
extends Node


@export var _broadcast: Array[AbInputPushKeyValue] = []


func notify_analog_value_to_relayed_with_key_name(key_name:String, analog_value:float):
    for broadcast in _broadcast:
        broadcast.set_analog_value(key_name, analog_value)
func notify_boolean_value_to_relayed_with_key_name(key_name:String, boolean_value:bool):
    for broadcast in _broadcast:
        broadcast.set_boolean_value(key_name, boolean_value)