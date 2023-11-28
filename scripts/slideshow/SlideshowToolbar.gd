extends Control

signal slider_changed
signal previous_slide
signal next_slide

@export var toolbar_appear_threshold: int
@export var slide_count: int
@export var slide_label: Label
@export var slide_slider: HSlider

var started: bool = false


func _process(_delta: float):
	if started: return
	
	slide_slider.max_value = slide_count - 1
	update_label(1)
	started = true


func _input(event):
	if event is InputEventMouseMotion:
		visible = event.position.y < toolbar_appear_threshold
		return
	
	if event.is_action_pressed("ui_left"):
		_on_previous_button_pressed()
		return
	
	if event.is_action_pressed("ui_right"):
		_on_next_button_pressed()
		return


func _on_slide_slider_drag_ended(value_changed):
	if (!value_changed): return
	
	update_label(int(slide_slider.value) + 1)
	slider_changed.emit(slide_slider.value)


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_fullscreen_button_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_previous_button_pressed():
	if slide_slider.value - 1 < 0: return
	
	slide_slider.value = slide_slider.value - 1
	update_label(int(slide_slider.value) + 1)
	previous_slide.emit()


func _on_next_button_pressed():
	if slide_slider.value + 1 >= slide_count: return
	
	slide_slider.value = slide_slider.value + 1
	update_label(int(slide_slider.value) + 1)
	next_slide.emit()

func update_label(value: int):
	slide_label.text = str(value) + '/' + str(slide_count)
