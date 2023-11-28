extends Control

@export var current_slide_index: int = 0
var previous_slide_index: int = 0
var started: bool = false

@onready var slides: Array[Node] = $Slides.get_children()
@onready var slideshow_toolbar = $SlideshowToolbar

func _ready():
	slideshow_toolbar.slide_count = len(slides)


func _process(_delta: float):
	if started: return
	
	for slide in slides:
		slide.visible = false
	
	slides[current_slide_index].visible = true
	slides[current_slide_index].can_appear(true)
	started = true


func _on_slideshow_toolbar_next_slide():
	previous_slide_index = current_slide_index
	current_slide_index += 1
	update_slide()


func _on_slideshow_toolbar_previous_slide():
	previous_slide_index = current_slide_index
	current_slide_index -= 1
	update_slide()


func _on_slideshow_toolbar_slider_changed(value: int):
	previous_slide_index = current_slide_index
	current_slide_index = value
	update_slide()


func update_slide():
	slides[previous_slide_index].can_disappear(true)


func _on_slide_disappeared():
	slides[current_slide_index].visible = true
	slides[current_slide_index].can_appear(true)
