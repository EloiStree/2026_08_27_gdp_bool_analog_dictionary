class_name  AbInputAnalogParsers
extends Node


var _parsers: Array[AbInputAnalogParserWithParams] = []

func append_parser(
	source_name: String,
	source_min_value: float ,
	source_max_value: float,
	destination_min_value: float,
	destination_max_value: float,
	death_zone_min_value: 	float,
	death_zone_max_value: 	float,
	destination_name: String ):
		
		var parser = AbInputAnalogParserWithParams.new(
			source_name,
			source_min_value,
			source_max_value,
			destination_min_value,
			destination_max_value,
			death_zone_min_value,
			death_zone_max_value,
			destination_name)
		_parsers.append(parser)

class AbInputAnalogParserWithParams:
	var source_name: String
	var source_min_value: float
	var source_max_value: float
	var destination_min_value: float
	var destination_max_value: float
	var death_zone_min_value: float
	var death_zone_max_value: float
	var destination_name: String

	var ref_source: AbInputResourceAnalogValue
	var ref_destiation: AbInputResourceAnalogValue

	func _init(
		source_name: String,
		source_min_value: float,
		source_max_value: float,
		destination_min_value: float,
		destination_max_value: float,
		death_zone_min_value: float,
		death_zone_max_value: float,
		destination_name: String):
		self.source_name = source_name
		self.source_min_value = source_min_value
		self.source_max_value = source_max_value
		self.destination_min_value = destination_min_value
		self.destination_max_value = destination_max_value
		self.death_zone_min_value = death_zone_min_value
		self.death_zone_max_value = death_zone_max_value
		self.destination_name = destination_name
		var ref_source = AbInputDictionary.get_singleton().get_analog_resource_reference_from_device_name(source_name)
		var ref_destiation = AbInputDictionary.get_singleton().get_analog_resource_reference_from_device_name(destination_name)
		setup_ref_source_destination(ref_source, ref_destiation)

	func setup_ref_source_destination(ref_source:AbInputResourceAnalogValue, ref_destiation:AbInputResourceAnalogValue):
		self.ref_source = ref_source
		self.ref_destiation = ref_destiation
		if self.ref_source != null:
			self.ref_source.add_value_changed_listener(_on_changed)

	func _on_changed(source: AbInputResourceAnalogValue,previous:float ,value: float):
		var percent_source = (value - source_min_value) / (source_max_value - source_min_value)
		var mapped_value = destination_min_value + percent_source * (destination_max_value - destination_min_value)
		if abs(mapped_value) > death_zone_min_value and abs(mapped_value) < death_zone_max_value:
			mapped_value = 0.0
		mapped_value = clamp(mapped_value, destination_min_value, destination_max_value)
		if ref_destiation != null:
			ref_destiation.set_analog_value(mapped_value)
