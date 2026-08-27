## Allow to store boolean value and subscribe to value changed event
## It is store in resource for the other developer code to be able to reference instead of asking dictionary all the time.

class_name AbInputResourceBooleanValue
extends Resource

@export var _boolean_name_id:String
@export var _boolean_value:bool
## Return self previous and new value.
@export var _value_changed_listeners:Array[Callable] = []

func set_boolean_value(value:bool) -> void:
	var value_changed :bool = _boolean_value != value
	if value_changed:
		var previous_value :bool = _boolean_value
		_boolean_value = value
		_notify_value_changed( value)

func get_boolean_value() -> bool:
	return _boolean_value

func get_boolean_name_id() -> String:
	return _boolean_name_id


func add_value_changed_listener(callback:Callable) -> void:
	if not _value_changed_listeners.has(callback):
		_value_changed_listeners.append(callback)

func remove_value_changed_listener(callback:Callable) -> void:
	if _value_changed_listeners.has(callback):
		_value_changed_listeners.erase(callback)

func _notify_value_changed( new_value:bool) -> void:
	for callback in _value_changed_listeners:
		callback.call(self, new_value)
