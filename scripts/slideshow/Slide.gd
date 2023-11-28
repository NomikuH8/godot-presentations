extends Panel

enum EnterAnimation {
	GROW,
	PASS_RIGHT
}

enum ExitAnimation {
	SHRINK,
	PASS_LEFT
}

signal slide_disappeared

@export var enter_animation: EnterAnimation = EnterAnimation.GROW
@export var exit_animation: ExitAnimation = ExitAnimation.SHRINK
@export var interactive_slide: bool = false
@export var interactive_text_start: int = 1
@export var text_appear: float = .03
@export var image_appear: float = .03

@onready var all_children = self.get_children()
@onready var images: Array[Node] = all_children.filter(func(c): return c is TextureRect)
@onready var labels = all_children.filter(func(c): return c is Label)
@onready var label_txts = labels.map(func(l: Label): return l.text)

@onready var animation_tree = $AnimationTree
@onready var text_timer = $TextTimer
@onready var image_timer = $ImageTimer

var current_image_index: int = 0
var current_label_index: int = 0
var current_label_txt_index: int = 0


func _ready():
	text_timer.wait_time = text_appear
	image_timer.wait_time = image_appear
	
	animation_tree['parameters/conditions/enter_grow'] = enter_animation == EnterAnimation.GROW
	animation_tree['parameters/conditions/exit_shrink'] = exit_animation == ExitAnimation.SHRINK
	animation_tree.active = true
	
	for i in images:
		i.get_child(0).play('slide_image/idle_out')
	
	for l in labels:
		l.text = ''


func _on_text_timer_timeout():
	if current_label_index > len(labels) - 1:
		text_timer.stop()
		return
	
	labels[current_label_index].text += label_txts[current_label_index][current_label_txt_index]
	current_label_txt_index += 1
	
	if labels[current_label_index].text == label_txts[current_label_index]:
		current_label_index += 1
		current_label_txt_index = 0


func _on_image_timer_timeout():
	if current_image_index > len(images) - 1:
		image_timer.stop()
		return
	
	images[current_image_index].get_child(0).play('slide_image/fade_in')
	current_image_index += 1


func _on_animation_tree_animation_finished(anim_name: String):
	if anim_name.contains('enter'):
		can_appear(false)
		text_timer.start()
		image_timer.start()
	
	if anim_name.contains('exit'):
		can_disappear(false)
		visible = false
		slide_disappeared.emit()

func can_appear(value: bool):
	animation_tree['parameters/conditions/can_enter'] = value

func can_disappear(value: bool):
	animation_tree['parameters/conditions/can_exit'] = value
