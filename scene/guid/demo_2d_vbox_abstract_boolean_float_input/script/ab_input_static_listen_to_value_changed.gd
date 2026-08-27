class_name AbInputStaticListenToValueChanged
extends Node


signal on_analog_value_changed_with_source(source:AbInputResourceAnalogValue, previous_value:float, new_value:float)
signal on_boolean_value_changed_with_source(source:AbInputResourceBooleanValue, new_value:bool)

signal on_analog_value_changed(device_name:String, previous_value:float, new_value:float)
signal on_boolean_value_changed(device_name:String,new_value:bool)


signal on_analog_value_changed_as_string(text:String)
signal on_boolean_value_changed_as_string(text:String)
signal on_any_value_changed_as_string(text:String)

signal on_device_event_received(device_name:String,text:String)
signal on_device_event_received_as_string(text:String)


@export var _use_string_log:bool = true
@export var _analog_format_string:String = "A|%s|%.1f"
@export var _boolean_format_string:String = "B|%s|%s"
@export var _any_format_string:String = "Any|%s|%s"
@export var _device_event_format_string:String = "T|%s|%s"

@export var _ignore_log_if_contains:Array[String]=["mouse"]

func _ready() -> void:
	var singleton:= AbInputDictionary.get_singleton()
	singleton.add_all_analog_value_changed_listener(_on_analog_value_changed)
	singleton.add_all_boolean_value_changed_listener(_on_boolean_value_changed)
	singleton.add_all_device_event_listener(_on_device_event_received)


func _exit_tree() -> void:
	var singleton:= AbInputDictionary.get_singleton()
	singleton.remove_all_analog_value_changed_listener(_on_analog_value_changed)
	singleton.remove_all_boolean_value_changed_listener(_on_boolean_value_changed)
	singleton.remove_all_device_event_listener(_on_device_event_received)

func _on_device_event_received(device_name:String, text:String) -> void:
	on_device_event_received.emit(device_name, text)
	if _use_string_log:
		if not is_ban_text_in_ignore_log(device_name):
			on_device_event_received_as_string.emit(String(_device_event_format_string) % [device_name, text])
			var a :String = _device_event_format_string% [device_name, text]
			on_device_event_received_as_string.emit(a)

func _on_analog_value_changed(source:AbInputResourceAnalogValue, previous_value:float, new_value:float) -> void:
	on_analog_value_changed_with_source.emit(source, previous_value, new_value)
	on_analog_value_changed.emit(source.get_analog_name_id(), previous_value, new_value)
	if _use_string_log:
		var text :String = String(_analog_format_string) % [source.get_analog_name_id(), (new_value )]
		text = text.to_lower()
		if not is_ban_text_in_ignore_log(text):
			on_analog_value_changed_as_string.emit(text)
			var a :String = _any_format_string% [source.get_analog_name_id(), str(new_value)]
			on_any_value_changed_as_string.emit(a)

func _on_boolean_value_changed(source:AbInputResourceBooleanValue, new_value:bool) -> void:
	on_boolean_value_changed_with_source.emit(source, new_value)
	on_boolean_value_changed.emit(source.get_boolean_name_id(), new_value)
	if _use_string_log:
		var text :String = String(_boolean_format_string) % [source.get_boolean_name_id(), str(new_value)]
		text = text.to_lower()
		if not is_ban_text_in_ignore_log(text):
			on_boolean_value_changed_as_string.emit(text)
			var a :String = _any_format_string% [source.get_boolean_name_id(), str(new_value)]
			on_any_value_changed_as_string.emit(a)


func is_ban_text_in_ignore_log(text:String) -> bool:
	for ban_text in _ignore_log_if_contains:
		if text.find(ban_text) != -1:
			return true
	return false
