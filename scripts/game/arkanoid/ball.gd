extends Area2D


var acceleration_x: float = 50.0
var acceleration_y: float = 50.0


func _ready():
	pass


func _process(delta):
	pass


func _physics_process(delta: float):
	position += Vector2(
		acceleration_x,
		acceleration_y
	) * 10 * delta
	
	if position.x < 90 or position.x > 1190:
		acceleration_x = -acceleration_x
	
	if position.y < 30 or position.y > 700:
		acceleration_y = -acceleration_y


func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body is Paddle:
		var angle = body.position.x - position.x
		acceleration_x = -angle
		acceleration_x = clamp(acceleration_x, -50, 50)
		acceleration_y = -acceleration_y
		return
	
	if body is StaticBody2D:
		acceleration_y = -acceleration_y
		
		if position.y + 
		if position.x < body.position.x:
		body.queue_free()
