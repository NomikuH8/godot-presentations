extends Control

@export var current_slide_index: int = 0

@onready var slides: Array[Node] = $Slides.get_children()
@onready var slideshow_toolbar = $SlideshowToolbar

func _ready():
	slideshow_toolbar.slide_count = len(slides)
	
	#for slide in slides:
	#	slide.visible = false
	
	update_slide(0)


func update_slide(previous_slide: int):
	var exit_shrink = slides[previous_slide].animation_tree['parameters/conditions/exit_shrink']
	if exit_shrink:
		slides[previous_slide].animation_tree['parameters/playback'].travel('slide_exit_shrink')
	
	var enter_grow = slides[previous_slide].animation_tree['parameters/conditions/enter_grow']
	if enter_grow:
		slides[current_slide_index].animation_tree['parameters/playback'].travel('slide_enter_grow')

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
