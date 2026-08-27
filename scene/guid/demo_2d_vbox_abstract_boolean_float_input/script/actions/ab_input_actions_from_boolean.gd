class_name AbInputActionsFromBoolean
extends Node




signal on_action_found( action:String)
signal on_action_found_with_source(input_name:String, value:bool, action:String)

@export var _use_debug_print:bool = false

var _device_inputs_to_actions:Dictionary[String,AbInputStoreDeviceInputsToActions] = {}	

func append_action(input_name:String, value:bool, action:String) -> void:
	input_name = input_name.strip_edges().to_lower()
	if _use_debug_print:
		print("Received: ", input_name, "  Value:", value)
	if not _device_inputs_to_actions.has(input_name):
		_device_inputs_to_actions[input_name] = AbInputStoreDeviceInputsToActions.new()
		_device_inputs_to_actions[input_name].set_input_name(input_name)
	_device_inputs_to_actions[input_name].append_action(value, action)



func trigger_action_from_input_name_and_value(input_name:String, value:bool) -> void:
	input_name = input_name.strip_edges().to_lower()
	if _device_inputs_to_actions.has(input_name):
		var actions = _device_inputs_to_actions[input_name].get_actions_for_value(value)
		for action in actions:
			on_action_found.emit(action)
			on_action_found_with_source.emit(input_name, value, action)




class AbInputStoreDeviceInputsToActions:
	var _input_name:String =""
	var _true_actions:Array[String]=[]
	var _false_actions:Array[String]=[]

	func set_input_name(input_name:String) -> void:
		self._input_name = input_name

	func get_actions_for_value(value:bool) -> Array[String]:
		if value:
			return _true_actions
		else:
			return _false_actions

	func get_true_actions() -> Array[String]:
		return _true_actions

	func get_false_actions() -> Array[String]:
		return _false_actions


	func clear_actions() -> void:
		self._true_actions.clear()
		self._false_actions.clear()


	func append_action(value:bool, action:String) -> void:
		if value:
			self._true_actions.append(action)
		else:
			self._false_actions.append(action)

	func append_true_action(action:String) -> void:
		self._true_actions.append(action)

	func append_false_action(action:String) -> void:
		self._false_actions.append(action)
