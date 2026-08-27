class_name AbUiInputKeyNameSliderChanged
extends AbUiInputKeyChanged

signal on_slider_value_changed(key_name:String, value:float)

@export var _slider:Slider
func _ready() -> void:
	if _slider:
		_slider.value_changed.connect(_on_slider_value_changed)

func _on_slider_value_changed(value: float) -> void:
	on_slider_value_changed.emit(get_key_name(), value)
	notify_analog_value_to_relayed(value)
