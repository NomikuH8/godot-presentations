extends VBoxContainer



func _ready() -> void:
	var children = get_children()
	
	for i in len(children):
		var c = children[i]
		
		if c is TerminalInput:
			if i + 1 < len(children):
				var c2: EnterCommandWait = children[i + 1]
				c.enter_pressed.connect(c2.start)
		
		if c is EnterCommandWait:
			if i + 1 < len(children):
				var c2: EnterCommandWait = children[i + 1]
				c.wait_finished.connect(c2.start)
			
			c.wait_finished.connect(scroll_to_bottom)


func scroll_to_bottom():
	var parent := get_parent()
	
	if parent is ScrollContainer:
		parent.set_deferred("scroll_vertical", parent.get_v_scroll_bar().max_value)
