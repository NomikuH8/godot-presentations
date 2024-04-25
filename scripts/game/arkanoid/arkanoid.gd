extends Node2D


@export var block_scene: PackedScene
@export var grid_size: Vector2 = Vector2(80, 120)
@export var grid_offset: Vector2 = Vector2(80, 40)

@onready var blocks := $Blocks


func _ready():
	create_playfield()


func _process(delta):
	pass


func _input(event):
	if event.is_action_pressed("reset_game"):
		for i in blocks.get_children():
			blocks.remove_child(i)
		
		create_playfield()


func create_playfield():
	for i in range(3):
		for j in range(8):
			var block = block_scene.instantiate()
			block.position = Vector2(j, i) * grid_size + grid_offset
			blocks.add_child(block)
