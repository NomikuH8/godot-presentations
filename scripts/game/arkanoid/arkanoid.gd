extends Node2D


@export var block_scene: PackedScene
@export var grid_size: Vector2 = Vector2(80, 120)
@export var grid_offset: Vector2 = Vector2(80, 40)

@onready var blocks := $Blocks
@onready var paddle := $Paddle
@onready var ball := $Ball


func _ready():
	paddle.ball = ball
	create_playfield()

func _process(_delta: float):
	if blocks.get_child_count() == 0:
		create_playfield()

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
