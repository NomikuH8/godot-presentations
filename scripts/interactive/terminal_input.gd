class_name TerminalInput
extends RichTextLabel


signal enter_pressed()


@export var prompt: String = "bbcoded $"
@export var text_to_write: String = ""
@export var cursor_text: String = "[bgcolor=white] [/bgcolor]"


var cursor_index_position: int = 0


func _ready() -> void:
	text = prompt + " " + cursor_text


func _unhandled_input(event: InputEvent) -> void:
	var slide: Control = (
		get_parent()
		.get_parent()
		.get_parent()
		.get_parent()
		.get_parent()
	)
	
	if not slide.visible:
		return
	
	if event is InputEventKey:
		if event.is_pressed():
			cursor_index_position += 1
			next_character()
		if event.keycode == KEY_ENTER:
			cursor_index_position = -1
			next_character(true)
			enter_pressed.emit()


func next_character(hide_cursor: bool = false) -> void:
	var txt = text_to_write.substr(0, cursor_index_position)
	
	text = prompt + " " + txt
	
	if not hide_cursor:
		text += cursor_text
