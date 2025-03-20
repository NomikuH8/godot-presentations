extends Area2D


@onready var collision_shape = $CollisionShape2D

var acceleration_x: float = 50.0
var acceleration_y: float = 50.0


func _physics_process(delta: float):
	position += Vector2(
		acceleration_x,
		acceleration_y
	) * 10 * delta
	
	if position.x < 24 or position.x > 1260:
		acceleration_x = -acceleration_x
	
	if position.y < 30:
		acceleration_y = 50.0
	
	if position.y > 700:
		acceleration_y = -50.0


func _input(event):
	if event.is_action_pressed("reset_ball"):
		position = Vector2(620, 502)


func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body is Paddle:
		var angle = body.position.x - position.x
		acceleration_x = -angle
		acceleration_x = clamp(acceleration_x, -50, 50)
		if position.y < body.position.y:
			acceleration_y = -acceleration_y
		return
	
	if body is StaticBody2D:
		acceleration_y = -acceleration_y
		
		if position.y - (collision_shape.shape.size.y / 2) < body.position.y:
			if position.x < body.position.x or position.x > body.position.x:
				acceleration_x = -acceleration_x
		
		body.queue_free()
