class_name AbUiInputLineEditToClipboard
extends Node


@export var _line_edit_group:Array[LineEdit] = []
@export var _button_to_trigger:Array[Button] = []
@export var _use_line_to_split: bool = true


func _ready() -> void:
	for button in _button_to_trigger:
		button.button_down.connect(push_line_editor_to_clipboard)

func push_line_editor_to_clipboard():
	var text:String = ""
	if _use_line_to_split:
		for line_edit in _line_edit_group:
			text += line_edit.text + "\n"
	else:
		for line_edit in _line_edit_group:
			text += line_edit.text
	DisplayServer.clipboard_set(text)
