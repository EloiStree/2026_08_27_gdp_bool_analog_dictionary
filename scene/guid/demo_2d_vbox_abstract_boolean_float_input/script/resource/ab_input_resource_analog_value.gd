## Allow to store analog value and subscribe to value changed event
## It is store in resource for the other developer code to be able to reference instead of asking dictionary all the time.

class_name AbInputResourceAnalogValue
extends Resource

@export var _analog_name_id:String
@export var _analog_value:float
@export var _value_changed_listeners:Array[Callable] = []

func set_analog_value(value:float) -> void:
	var previous_value :float = _analog_value
	var value_changed :bool = _analog_value != value
	_analog_value = value
	if value_changed:
		_notify_value_changed(previous_value, value)

func get_analog_value() -> float:
	return _analog_value

func get_analog_name_id() -> String:
	return _analog_name_id


func add_value_changed_listener(callback:Callable) -> void:
	if not _value_changed_listeners.has(callback):
		_value_changed_listeners.append(callback)

func remove_value_changed_listener(callback:Callable) -> void:
	if _value_changed_listeners.has(callback):
		_value_changed_listeners.erase(callback)

func _notify_value_changed(previous_value:float, new_value:float) -> void:
	for callback in _value_changed_listeners:
		callback.call(self, previous_value, new_value)
