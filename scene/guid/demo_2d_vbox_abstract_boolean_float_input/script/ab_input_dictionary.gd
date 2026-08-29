## Provides an abstraction layer similar to Godot and Unity's input action systems.
## Decouples device input sources from boolean and analog value handling for flexible input management.
## Allows listeners to hook into input changes without integrating into a formal action system.

class_name AbInputDictionary
extends Node


@export var _analog_dictionary:Dictionary[String,AbInputResourceAnalogValue]
@export var _boolean_dictionary:Dictionary[String,AbInputResourceBooleanValue]

static var _device_event_listeners:Array[Callable] =[]
static var _analog_value_changed_listeners:Array[Callable] = []
static var _boolean_value_changed_listeners:Array[Callable] = []

static var _singleton:AbInputDictionary
static func get_singleton() -> AbInputDictionary:
	return _singleton

@export var _is_singleton:bool

func _ready() -> void:
	if _is_singleton:
		_singleton = self

#region ADD/REMOVE GLOBAL LISTENER

func add_all_device_event_listener(callback:Callable):
	if not _device_event_listeners.has(callback):
		_device_event_listeners.append(callback)

func remove_all_device_event_listener(callback:Callable):
	if _device_event_listeners.has(callback):
		_device_event_listeners.erase(callback)

func add_all_analog_value_changed_listener(callback:Callable) -> void:
	if not _analog_value_changed_listeners.has(callback):
		_analog_value_changed_listeners.append(callback)

func remove_all_analog_value_changed_listener(callback:Callable) -> void:
	if _analog_value_changed_listeners.has(callback):
		_analog_value_changed_listeners.erase(callback)

func add_all_boolean_value_changed_listener(callback:Callable) -> void:
	if not _boolean_value_changed_listeners.has(callback):
		_boolean_value_changed_listeners.append(callback)

func remove_all_boolean_value_changed_listener(callback:Callable) -> void:
	if _boolean_value_changed_listeners.has(callback):
		_boolean_value_changed_listeners.erase(callback)

#region END ADD/REMOVE GLOBAL LISTENER


#region SET

func trigger_event_from_device_name(device_name:String, trigger_value:String):
	device_name = device_name.to_lower()
	for c in _device_event_listeners:
		c.call(device_name, trigger_value)

func set_analog_from_device_name(device_name:String, value:float):
	device_name = device_name.to_lower()
	_create_analog_if_not_existing(device_name)
	_analog_dictionary[device_name].set_analog_value(value)
	
func set_boolean_from_device_name(device_name:String, value:bool):
	device_name = device_name.to_lower()
	_create_boolean_if_not_existing(device_name)
	_boolean_dictionary[device_name].set_boolean_value(value)

#endregion


#region GET
func get_analog_from_device_name(device_name:String) -> float:
	device_name =device_name.to_lower()
	_create_analog_if_not_existing(device_name)
	return _analog_dictionary[device_name].get_analog_value()

func get_boolean_from_device_name(device_name:String) -> bool:
	device_name =device_name.to_lower()
	_create_boolean_if_not_existing(device_name)
	return _boolean_dictionary[device_name].get_boolean_value()

func get_analog_resource_reference_from_device_name(device_name:String) -> AbInputResourceAnalogValue:
	device_name =device_name.to_lower()
	_create_analog_if_not_existing(device_name)
	return _analog_dictionary[device_name]

func get_boolean_resource_reference_from_device_name(device_name:String) -> AbInputResourceBooleanValue:
	device_name =device_name.to_lower()
	_create_boolean_if_not_existing(device_name)
	return _boolean_dictionary[device_name]

#endregion


func add_analog_value_changed_listener(device_name:String, callable:Callable):
	_create_analog_if_not_existing(device_name)
	_analog_dictionary[device_name].add_value_changed_listener(callable)

func add_boolean_value_changed_listener(device_name:String, callable:Callable):
	_create_boolean_if_not_existing(device_name)
	_boolean_dictionary[device_name].add_value_changed_listener(callable)


func remove_analog_value_changed_listener(device_name:String, callable:Callable):
	_create_analog_if_not_existing(device_name)
	_analog_dictionary[device_name].remove_value_changed_listener(callable)

func remove_boolean_value_changed_listener(device_name:String, callable:Callable):
	_create_boolean_if_not_existing(device_name)
	_boolean_dictionary[device_name].remove_value_changed_listener(callable)




#region private
func _create_analog_if_not_existing(device_name:String) -> void:
	device_name = device_name.to_lower()
	if not _analog_dictionary.has(device_name):
		var analog_resource :AbInputResourceAnalogValue = AbInputResourceAnalogValue.new()
		analog_resource._analog_name_id = device_name
		analog_resource.add_value_changed_listener(_on_analog_value_changed_notify_static_listener)
		_analog_dictionary[device_name] = analog_resource

func _create_boolean_if_not_existing(device_name:String) -> void:
	if not _boolean_dictionary.has(device_name):
		var boolean_resource :AbInputResourceBooleanValue = AbInputResourceBooleanValue.new()
		boolean_resource._boolean_name_id = device_name
		boolean_resource.add_value_changed_listener(_on_boolean_value_changed_notify_static_listener)
		_boolean_dictionary[device_name] = boolean_resource

func _on_analog_value_changed_notify_static_listener(source:AbInputResourceAnalogValue, previous_value:float, new_value:float) -> void:
	for callback in _analog_value_changed_listeners:
		callback.call(source, previous_value, new_value)

func _on_boolean_value_changed_notify_static_listener(source:AbInputResourceBooleanValue, new_value:bool) -> void:
	for callback in _boolean_value_changed_listeners:
		callback.call(source, new_value)

#endregion
