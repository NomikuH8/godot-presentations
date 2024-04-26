extends Node2D
class_name Paddle


@export var is_player: bool = false
@export var player_movement_speed: float = 100.0
@export var ai_movement_speed: float = 40.0

var going_left: bool = false
var going_right: bool = false
var ball: Node2D


func _physics_process(delta: float):
	if not is_player:
		ai_play(delta)
		return
	
	if going_left:
		position.x -= player_movement_speed * 10.0 * delta
	
	if going_right:
		position.x += player_movement_speed * 10.0 * delta
	
	position.x = clamp(position.x, 90, 1190)


func _input(event: InputEvent):
	if not is_player:
		return
	
	if event.is_action_pressed("left"):
		going_left = true
	if event.is_action_released("left"):
		going_left = false
	
	if event.is_action_pressed("right"):
		going_right = true
	if event.is_action_released("right"):
		going_right = false


func ai_play(delta: float):
	going_left = ball.position.x < position.x + (randf() * 50)
	going_right = ball.position.x > position.x - (randf() * 50)
	
	#if ball.position.y > position.y:
		#return
	
	if going_left:
		position.x -= ai_movement_speed * 10.0 * delta
	
	if going_right:
		position.x += ai_movement_speed * 10.0 * delta
	
	position.x = clamp(position.x, 90, 1190)
