class_name AbInputAddPrefixToKeyValue
extends Node

@export var _prefix_to_append:String
@export var _suffix_to_append:String

signal on_parsed_key_value_analog(key:String, analog:float)
signal on_parsed_key_value_boolean(key:String, boolean:bool)
signal on_parsed_key_value_text(key:String, text:String)


func push_in_key_value_analog(key:String, analog:float):
	on_parsed_key_value_analog.emit(_prefix_to_append + key + _suffix_to_append, analog)

func push_in_key_value_boolean(key:String, boolean:bool):
	on_parsed_key_value_boolean.emit(_prefix_to_append + key + _suffix_to_append, boolean)

func push_in_key_value_text(key:String, text:String):
	on_parsed_key_value_text.emit(_prefix_to_append + key + _suffix_to_append, text)
