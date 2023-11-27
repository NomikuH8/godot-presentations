extends Panel

enum EnterAnimation {
	GROW,
	PASS_RIGHT
}

enum ExitAnimation {
	SHRINK,
	PASS_LEFT
}

@export var enter_animation: EnterAnimation = EnterAnimation.GROW
@export var exit_animation: ExitAnimation = ExitAnimation.SHRINK
@export var interactive_slide: bool = false
@export var interactive_text_start: int = 1
@export var text_appear: float = .03
@export var image_appear: float = .03

@onready var all_children = self.get_children()
@onready var images = all_children.filter(func(c): return c is TextureRect)
@onready var labels = all_children.filter(func(c): return c is Label)
@onready var label_txts = labels.map(func(l: Label): return l.text)

@onready var animation_tree = $AnimationTree
@onready var text_timer = $TextTimer
@onready var image_timer = $ImageTimer

var current_label_index: int = 0
var current_label_txt_index: int = 0


func _ready():
	text_timer.wait_time = text_appear
	image_timer.wait_time = image_appear
	
	animation_tree['parameters/conditions/enter_grow'] = enter_animation == EnterAnimation.GROW
	animation_tree['parameters/conditions/exit_shrink'] = exit_animation == ExitAnimation.SHRINK
	animation_tree.active = true
	
	for i in images:
		i.visible = false
	
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


func _on_animation_tree_animation_finished(anim_name):
	print(anim_name)
	if anim_name == 'slide/enter_grow':
		text_timer.start()
