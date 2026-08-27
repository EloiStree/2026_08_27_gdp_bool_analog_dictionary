class_name AbInputActionsRangeInOut
extends Node




signal on_action_found( action:String)
signal on_action_found_with_source(input_name:String, value:bool, action:String)

@export var _use_debug_print:bool = false

var _device_inputs_to_actions:Dictionary[String,AbInputStoreDeviceInputsToActions] = {}	

func append_action(input_name:String, value_min:float, value_max:float, in_range:bool, action:String) -> void:
	input_name = input_name.strip_edges().to_lower()
	if _use_debug_print:
		print("Received: ", input_name, "  Value Min:", value_min, "  Value Max:", value_max, "  In Range:", in_range, "  Action:", action)
	if not _device_inputs_to_actions.has(input_name):
		_device_inputs_to_actions[input_name] = AbInputStoreDeviceInputsToActions.new()
		_device_inputs_to_actions[input_name].set_input_name(input_name)

	_device_inputs_to_actions[input_name].append_action_in_of_range(value_min, value_max, in_range, action)
	
func trigger_action_from_input_name_with_previous_and_current_value(input_name:String, previous:float, value:float) -> void:
	trigger_action_from_input_name_and_value(input_name, value)

func trigger_action_from_input_name_and_value(input_name:String, value:float) -> void:
	input_name = input_name.strip_edges().to_lower()
	if _device_inputs_to_actions.has(input_name):
		var actions = _device_inputs_to_actions[input_name].get_actions_and_set(value)
		for action in actions:
			on_action_found.emit(action)
			on_action_found_with_source.emit(input_name, value, action)



class AbInputStoreDeviceInputsToActions:
	var _input_name:String =""
	var _previous_value:float=0.0
	var _current_value:float=0.0
	var _range_in_out_actions:Array[AbInputStoreRangeInOutToActions]=[]

	func set_input_name(input_name:String) -> void:
		self._input_name = input_name

	func get_actions_and_set(value:float) -> Array[String]:
		if value==_current_value:
			return []

		_previous_value = _current_value
		_current_value = value
		var actions:Array[String]=[]
		for range_in_out_actions in _range_in_out_actions:
			if range_in_out_actions.is_value_in_range(value) and \
			not range_in_out_actions.is_value_in_range(_previous_value):
				actions.append_array(range_in_out_actions.get_in_range_actions())
			elif range_in_out_actions.is_value_out_of_range(value) and \
			not range_in_out_actions.is_value_out_of_range(_previous_value):
				actions.append_array(range_in_out_actions.get_out_of_range_actions())
		return actions


	
	func append_action_in_of_range(value_min:float, value_max:float, is_in_range:bool, action:String) -> void:
		if value_min > value_max:
			var temp = value_min
			value_min = value_max
			value_max = temp
		
		for range_in_out_actions in _range_in_out_actions:
			if range_in_out_actions.is_same_range(value_min, value_max):
				if is_in_range:
					range_in_out_actions.append_in_range_action(action)
				else:
					range_in_out_actions.append_out_of_range_action(action)
				return
		var new_range_in_out_actions = AbInputStoreRangeInOutToActions.new()
		new_range_in_out_actions.set_range(value_min, value_max)
		if is_in_range:
			new_range_in_out_actions.append_in_range_action(action)
		else:
			new_range_in_out_actions.append_out_of_range_action(action)
		_range_in_out_actions.append(new_range_in_out_actions)

	
class AbInputStoreRangeInOutToActions:
	var _range_min:float=0.0
	var _range_max:float=0.0
	var _in_range_actions:Array[String]=[]
	var _out_of_range_actions:Array[String]=[]

	func set_range(range_min:float, range_max:float) -> void:
		self._range_min = range_min
		self._range_max = range_max
		if _range_min > _range_max:
			var temp = _range_min
			_range_min = _range_max
			_range_max = temp

	func is_value_in_range(value:float) -> bool:
		return value >= _range_min and value <= _range_max

	func is_value_out_of_range(value:float) -> bool:
		return value < _range_min or value > _range_max

	func get_in_range_actions() -> Array[String]:
		return _in_range_actions

	func get_out_of_range_actions() -> Array[String]:
		return _out_of_range_actions

	func is_same_range(range_min:float, range_max:float) -> bool:
		if range_min > range_max:
			var temp = range_min
			range_min = range_max
			range_max = temp
		return _range_min == range_min and _range_max == range_max

	func append_in_range_action(action:String) -> void:
		_in_range_actions.append(action)

	func append_out_of_range_action(action:String) -> void:
		_out_of_range_actions.append(action)

	func has_in_range_actions() -> bool:
		return _in_range_actions.size() > 0

	func has_out_of_range_actions() -> bool:
		return _out_of_range_actions.size() > 0
