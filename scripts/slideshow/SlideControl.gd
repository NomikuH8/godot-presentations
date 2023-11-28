extends Control

@export var current_slide_index: int = 0

@onready var slides: Array[Node] = $Slides.get_children()
@onready var slideshow_toolbar = $SlideshowToolbar

func _ready():
	slideshow_toolbar.slide_count = len(slides)
	
	#for slide in slides:
	#	slide.visible = false
	slides[current_slide_index].animation_tree['parameters/conditions/can_enter'] = true


func update_slide(previous_slide: int):
	slides[previous_slide].animation_tree['parameters/conditions/can_exit'] = true

func _on_slideshow_toolbar_next_slide():
	if current_slide_index >= len(slides) - 1:
		return
	
	var previous_slide: int = current_slide_index
	current_slide_index += 1
	update_slide(previous_slide)


func _on_slideshow_toolbar_previous_slide():
	if current_slide_index <= 0:
		return
	
	var previous_slide: int = current_slide_index
	current_slide_index -= 1
	update_slide(previous_slide)


func _on_slideshow_toolbar_slider_changed(value: int):
	var previous_slide: int = current_slide_index
	current_slide_index = value
	update_slide(previous_slide)


func _on_panel_slide_disappeared():
	slides[current_slide_index].animation_tree['parameters/conditions/can_enter'] = true
