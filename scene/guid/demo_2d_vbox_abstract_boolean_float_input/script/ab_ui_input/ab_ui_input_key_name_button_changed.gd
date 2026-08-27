class_name AbUiInputKeyNameButtonChanged
extends AbUiInputKeyChanged

signal on_button_value_changed(key_name:String, value:bool)
@export var _button:Button
func _ready() -> void:
	if _button:
		_button.button_down.connect(_on_button_down)
		_button.button_up.connect(_on_button_up)

func _on_button_down() -> void:
	on_button_value_changed.emit(get_key_name(), true)
	notify_boolean_value_to_relayed(true)

func _on_button_up() -> void:
	on_button_value_changed.emit(get_key_name(), false)
	notify_boolean_value_to_relayed(false)
