extends Panel

enum EnterAnimation {
	GROW,
	PASS_LEFT,
	ROTATE_LEFT,
	ROTATE_RIGHT
}

enum ExitAnimation {
	SHRINK,
	PASS_RIGHT,
	ROTATE_LEFT,
	ROTATE_RIGHT
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
	
	equal_animation_condition('enter_grow', true, EnterAnimation.GROW)
	equal_animation_condition('enter_pass_left', true, EnterAnimation.PASS_LEFT)
	equal_animation_condition('enter_rotate_left', true, EnterAnimation.ROTATE_LEFT)
	equal_animation_condition('enter_rotate_right', true, EnterAnimation.ROTATE_RIGHT)
	equal_animation_condition('exit_shrink', false, ExitAnimation.SHRINK)
	equal_animation_condition('exit_pass_right', false, ExitAnimation.PASS_RIGHT)
	equal_animation_condition('exit_rotate_left', false, ExitAnimation.ROTATE_LEFT)
	equal_animation_condition('exit_rotate_right', false, ExitAnimation.ROTATE_RIGHT)
	animation_tree.active = true
	
	var fixed_label_txts: Array[String] = []
	
	for l in label_txts:
		l = l.c_escape()
		print(l)
		l = l.replace("\\r\\n", "\\n")
		print(l)
		l = l.c_unescape()
		fixed_label_txts.append(l)
	
	label_txts = fixed_label_txts
	
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


func _input(event: InputEvent):
	if event.is_action_pressed("activate"):
		visible = !visible


func equal_animation_condition(condition: String, is_enter: bool, to_equal):
	if is_enter:
		animation_tree['parameters/conditions/' + condition] = enter_animation == to_equal
	else:
		animation_tree['parameters/conditions/' + condition] = exit_animation == to_equal


func can_appear(value: bool):
	animation_tree['parameters/conditions/can_enter'] = value


func can_disappear(value: bool):
	animation_tree['parameters/conditions/can_exit'] = value
