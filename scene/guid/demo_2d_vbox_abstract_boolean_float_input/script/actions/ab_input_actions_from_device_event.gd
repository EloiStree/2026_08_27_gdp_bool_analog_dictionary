class_name AbInputActionsFromDeviceEvent
extends Node


signal on_action_found( action:String)
signal on_action_found_with_source(device_name:String, trigger_event:String, action:String)

@export var _use_debug_print:bool = false

var _device_trigers_to_commands:Dictionary[String,AbInputStoreDeviceTriggersToCommands] = {}	

func append_action(device_name:String, trigger_event:String, action:String) -> void:
	device_name = device_name.strip_edges().to_lower()

	print("---> ADD: ", device_name, "  Event:", trigger_event)
	if _use_debug_print:
		print("Received: ", device_name, "  Event:", trigger_event)

	if not _device_trigers_to_commands.has(device_name):
		_device_trigers_to_commands[device_name] = AbInputStoreDeviceTriggersToCommands.new()
		_device_trigers_to_commands[device_name].device_name = device_name
	_device_trigers_to_commands[device_name].append_action(trigger_event, action)

func trigger_action(device_name:String, trigger_event:String) -> void:
	print("---> trigger_action: ", device_name, "  Event:", trigger_event)
	device_name = device_name.strip_edges().to_lower()
	if _device_trigers_to_commands.has(device_name):
		var actions = _device_trigers_to_commands[device_name].get_actions_for_trigger_name(trigger_event)
		for action in actions:
			on_action_found.emit(action)
			on_action_found_with_source.emit(device_name, trigger_event, action)


class AbInputStoreTriggerToCommands:
	var _trigger_name:String=""
	var _commands:Array[String]=[]

	func set_trigger_name(trigger_name:String) -> void:
		self._trigger_name = trigger_name

	func get_trigger_name() -> String:
		return self._trigger_name

	func get_commands() -> Array[String]:
		return self._commands


	func clear_commands() -> void:
		self._commands.clear()

	func set_as_actions(commands:Array[String]) -> void:
		self._commands = commands

	func set_as_action(command:String) -> void:
		self._commands.clear()
		self._commands.append(command)

	func append_action(command:String) -> void:
		self._commands.append(command)

	func append_actions(commands:Array[String]) -> void:
		for command in commands:
			self._commands.append(command)

class AbInputStoreDeviceTriggersToCommands:
	var device_name:String =""
	var triggers_to_commands:Dictionary[String,AbInputStoreTriggerToCommands] = {}


	func append_action(trigger_name:String, command:String) -> void:
		if not triggers_to_commands.has(trigger_name):
			var trigger_to_commands = AbInputStoreTriggerToCommands.new()
			trigger_to_commands.set_trigger_name(trigger_name)
			triggers_to_commands[trigger_name] = trigger_to_commands
		triggers_to_commands[trigger_name].append_action(command)

	func get_actions_for_trigger_name(trigger_name:String) -> Array[String]:
		if triggers_to_commands.has(trigger_name):
			return triggers_to_commands[trigger_name].get_commands()
		else:	
			return []
