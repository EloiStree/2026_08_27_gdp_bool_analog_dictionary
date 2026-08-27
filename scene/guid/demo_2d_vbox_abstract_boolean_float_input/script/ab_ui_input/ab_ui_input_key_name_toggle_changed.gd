class_name AbUiInputKeyNameToggleChanged
extends AbUiInputKeyChanged

signal on_button_value_changed(key_name:String, value:bool)

@export var _button:Button
func _ready() -> void:
	if _button:
		_button.toggled.connect(_on_button_toggled)

func _on_button_toggled(button_pressed: bool) -> void:
	on_button_value_changed.emit(get_key_name(), button_pressed)
	notify_boolean_value_to_relayed(button_pressed)
