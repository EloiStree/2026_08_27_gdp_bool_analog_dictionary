class_name  AbInputAnalogToFormatS2W
extends Node

signal on_index_integer_changed(
	player_index: int,
	value: int
)
signal on_index_integer_changed_with_anti_spam(
	player_index: int,
	value: int
)

signal on_index_integer_changed_formated(text:String)

var _index_value_format_string:String = "sc:%0d|%1d"
var _analog_to_gamepad_joysticks: Array[AbInputGamepadS2W] = []
var _analog_to_gamepad_motors: Array[AbInputMotorS2W] = []


# func _ready():
# 	append_ab_input_analog_to_gamepad_joystick("wingman_horizontal", "wingman_vertical", "wingman_twist", "xbox one s controller|s0|a3", 1.0, -1.0, 1,notify_index_integer_changed)

# #	append_ab_input_analog_to_gamepad_joystick("xbox one s controller|s0|a0", "xbox one s controller|s0|a1", "xbox one s controller|s0|a2", "xbox one s controller|s0|a3", 1.0, -1.0, 1,notify_index_integer_changed)
# 	append_ab_input_analog_to_motor_with("xbox one s controller|s0|a5", 0, 1.0, 1, 4,notify_index_integer_changed)
# 	append_ab_input_analog_to_motor_with("xbox one s controller|s0|a6", 0, 1.0, 1, 5,notify_index_integer_changed)

func notify_index_integer_changed(player_index: int, value: int):
	on_index_integer_changed.emit(player_index, value)
	on_index_integer_changed_formated.emit(_index_value_format_string % [player_index, value])


func append_ab_input_analog_to_gamepad_joystick(
	source_jlh_name: String,
	source_jlv_name: String,
	source_jrh_name: String,
	source_jrv_name: String,
	source_min_value: float,
	source_max_value: float,
	player_index: int):
	_append_ab_input_analog_to_gamepad_joystick_with_callback(source_jlh_name, source_jlv_name, source_jrh_name, source_jrv_name, source_min_value, source_max_value, player_index, notify_index_integer_changed)

func _append_ab_input_analog_to_gamepad_joystick_with_callback(
	source_jlh_name: String,
	source_jlv_name: String,
	source_jrh_name: String,
	source_jrv_name: String,
	source_min_value: float,
	source_max_value: float,
	player_index: int,
	index_integer_changed_callback: Callable):
	var new_analog_to_gamepad_joystick = AbInputGamepadS2W.new(
		source_jlh_name,
		source_jlv_name,
		source_jrh_name,
		source_jrv_name,
		source_min_value,
		source_max_value,
		player_index,
		index_integer_changed_callback)
	_analog_to_gamepad_joysticks.append(new_analog_to_gamepad_joystick)


func append_ab_input_analog_to_motor(
	source_name: String,
	source_min_value: float,
	source_max_value: float,
	destination_player_index: int,
	destination_motor_index: int):
	_append_ab_input_analog_to_motor_with_callback(source_name, source_min_value, source_max_value, destination_player_index, destination_motor_index, notify_index_integer_changed)

func _append_ab_input_analog_to_motor_with_callback(
	source_name: String,
	source_min_value: float,
	source_max_value: float,
	destination_player_index: int,
	destination_motor_index: int,
	index_integer_changed_callback: Callable):
	var new_analog_to_gamepad_motor = AbInputMotorS2W.new(
		source_name,
		source_min_value,
		source_max_value,
		destination_player_index,
		destination_motor_index,
		index_integer_changed_callback)
	_analog_to_gamepad_motors.append(new_analog_to_gamepad_motor)



@export var _frame_check_interval: float = 0.1
var _frame_check_timer: float = 0.0

func _ready():
	set_process(true)

func _process(delta: float) -> void:
	_frame_check_timer += delta
	if _frame_check_timer >= _frame_check_interval:
		_frame_check_timer = 0.0
		frame_check()

func frame_check() -> void:
	for analog_to_gamepad_joystick in _analog_to_gamepad_joysticks:
		if analog_to_gamepad_joystick.send_info_cooldown_timer > 0.0:
			analog_to_gamepad_joystick.send_info_cooldown_timer -= _frame_check_interval
		if analog_to_gamepad_joystick.send_info_cooldown_timer <= 0.0:
			analog_to_gamepad_joystick.send_info_cooldown_timer = 0.0
		if analog_to_gamepad_joystick.send_info_cooldown_timer == 0.0 and \
			analog_to_gamepad_joystick.last_frame_check_value != analog_to_gamepad_joystick.previous_value:
			analog_to_gamepad_joystick.send_info_cooldown_timer = 0.1
			analog_to_gamepad_joystick.last_frame_check_value = analog_to_gamepad_joystick.previous_value
			on_index_integer_changed_with_anti_spam.emit(analog_to_gamepad_joystick.player_index, analog_to_gamepad_joystick.previous_value)

	for analog_to_gamepad_motor in _analog_to_gamepad_motors:
		if analog_to_gamepad_motor.send_info_cooldown_timer > 0.0:
			analog_to_gamepad_motor.send_info_cooldown_timer -= _frame_check_interval
		if analog_to_gamepad_motor.send_info_cooldown_timer <= 0.0:
			analog_to_gamepad_motor.send_info_cooldown_timer = 0.0
		if analog_to_gamepad_motor.send_info_cooldown_timer == 0.0 and \
			analog_to_gamepad_motor.last_frame_check_value != analog_to_gamepad_motor.previous_value:
			analog_to_gamepad_motor.send_info_cooldown_timer = 0.1
			analog_to_gamepad_motor.last_frame_check_value = analog_to_gamepad_motor.previous_value
			on_index_integer_changed_with_anti_spam.emit(analog_to_gamepad_motor.destination_player_index, analog_to_gamepad_motor.previous_value)


class AbInputGamepadS2W:
	enum { JLH, JLV, JRH, JRV }

	var source_jlh_name: String
	var source_jlv_name: String
	var source_jrh_name: String
	var source_jrv_name: String
	var source_min_value: float= -1.0
	var source_max_value: float=  1.0
	var player_index: int
	var previous_value: int = 0 #1899887766

	var current_value_jlh_0_1_99:int = 0
	var current_value_jlv_0_1_99:int = 0
	var current_value_jrh_0_1_99:int = 0
	var current_value_jrv_0_1_99:int = 0

	var source_jlh_name_ref: AbInputResourceAnalogValue
	var source_jlv_name_ref: AbInputResourceAnalogValue
	var source_jrh_name_ref: AbInputResourceAnalogValue
	var source_jrv_name_ref: AbInputResourceAnalogValue

	var index_integer_changed_callback: Callable


	var last_frame_check_value:int
	var send_info_cooldown_timer: float = 0.1


	func _init(
		source_jlh_name: String,
		source_jlv_name: String,
		source_jrh_name: String,
		source_jrv_name: String,
		source_min_value: float,
		source_max_value: float,
		player_index: int,
		index_integer_changed_callback: Callable):
		self.source_jlh_name = source_jlh_name
		self.source_jlv_name = source_jlv_name
		self.source_jrh_name = source_jrh_name
		self.source_jrv_name = source_jrv_name
		self.source_min_value = source_min_value
		self.source_max_value = source_max_value
		self.player_index = player_index
		source_jlh_name_ref = AbInputDictionary.get_singleton().get_analog_resource_reference_from_device_name(source_jlh_name)
		source_jlv_name_ref = AbInputDictionary.get_singleton().get_analog_resource_reference_from_device_name(source_jlv_name)
		source_jrh_name_ref = AbInputDictionary.get_singleton().get_analog_resource_reference_from_device_name(source_jrh_name)
		source_jrv_name_ref = AbInputDictionary.get_singleton().get_analog_resource_reference_from_device_name(source_jrv_name)
		source_jlh_name_ref.add_value_changed_listener(on_changed_jlh)
		source_jlv_name_ref.add_value_changed_listener(on_changed_jlv)
		source_jrh_name_ref.add_value_changed_listener(on_changed_jrh)
		source_jrv_name_ref.add_value_changed_listener(on_changed_jrv)
		self.index_integer_changed_callback = index_integer_changed_callback

	func on_changed_jlh(source: AbInputResourceAnalogValue, previous: float, value: float):
		if value == 0.0:
			current_value_jlh_0_1_99 = 0
		else:
			
			current_value_jlh_0_1_99 = int(clamp((-value - source_min_value) / (source_max_value - source_min_value) * 99.0, 1, 99.0))

		update_and_emit()

	func on_changed_jrh(source: AbInputResourceAnalogValue, previous: float, value: float):
		if value == 0.0:
			current_value_jrh_0_1_99 = 0
		else:
			current_value_jrh_0_1_99 = int(clamp((-value - source_min_value) / (source_max_value - source_min_value) * 98.0, 1, 99.0))
		update_and_emit()

	func on_changed_jlv(source: AbInputResourceAnalogValue, previous: float, value: float):
		if value == 0.0:
			current_value_jlv_0_1_99 = 0
		else:
			current_value_jlv_0_1_99 = int(clamp((value - source_min_value) / (source_max_value - source_min_value) * 98.0, 1, 99.0))
		update_and_emit()
	func on_changed_jrv(source: AbInputResourceAnalogValue, previous: float, value: float):
		if value == 0.0:
			current_value_jrv_0_1_99 = 0
		else:
			current_value_jrv_0_1_99 = int(clamp((value - source_min_value) / (source_max_value - source_min_value) * 98.0, 1, 99.0))
		update_and_emit()

	func update_and_emit():
		var new_value = 1800000000
		new_value+= current_value_jlh_0_1_99 * 1000000
		new_value+= current_value_jlv_0_1_99 * 10000
		new_value+= current_value_jrh_0_1_99 * 100
		new_value+= current_value_jrv_0_1_99
	
		if new_value != previous_value:
			previous_value = new_value
			if index_integer_changed_callback != null:
				index_integer_changed_callback.call(player_index, new_value)


class AbInputMotorS2W:
	var source_name: String
	var source_min_value: float = 0.0
	var source_max_value: float = 1.0
	var destination_player_index: int
	var destination_motor_index: int
	const destination_min_value: float =1
	const destination_max_value: float =99999
	
	var index_integer_changed_callback: Callable

	var ref_source: AbInputResourceAnalogValue

	var motor_value_as_s2w: int =0
	var previous_value:int
	var last_frame_check_value:int
	var send_info_cooldown_timer: float = 0.0

	func _init(
		source_name: String,
		source_min_value: float,
		source_max_value: float,
			destination_player_index: int,
			destination_motor_index: int,
			index_integer_changed_callback: Callable):
		self.source_name = source_name
		self.source_min_value = source_min_value
		self.source_max_value = source_max_value
		self.destination_player_index = destination_player_index
		self.destination_motor_index = destination_motor_index
		self.index_integer_changed_callback = index_integer_changed_callback
		var source: AbInputResourceAnalogValue = AbInputDictionary.get_singleton().get_analog_resource_reference_from_device_name(source_name)
		setup_ref_source_destination(source)

	func setup_ref_source_destination(ref_source:AbInputResourceAnalogValue):
		self.ref_source = ref_source
		if self.ref_source != null:
			self.ref_source.add_value_changed_listener(_on_changed)

	func _on_changed(source: AbInputResourceAnalogValue,previous:float ,value: float):
		var percent_source = (value - source_min_value) / (source_max_value - source_min_value)
		var mapped_value = destination_min_value + percent_source * (destination_max_value - destination_min_value)
		mapped_value = clamp(mapped_value, destination_min_value, destination_max_value)
		var motor_value_99999 = int(mapped_value)
		var motor_index_99900000 = self.destination_motor_index*100000
		var int_value =-( 1600000000 + motor_value_99999 + motor_index_99900000)
		if int_value != previous_value:
			previous_value = int_value
			if index_integer_changed_callback != null:
				index_integer_changed_callback.call(self.destination_player_index, int_value)
