extends Panel



@onready var container: VBoxContainer = %Container



func _ready() -> void:
	var children = container.get_children()
	
	children.pop_front()
	
	for c in children:
		if c is RichTextLabel:
			c.visible = false
