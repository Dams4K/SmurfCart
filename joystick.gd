extends TouchScreenButton

@export var horizontal := true
@export var vertical := false

var is_dragging := false

var joystick_position: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if is_pressed():
		var shape_rect: Rect2 = shape.get_rect()
		
		if horizontal:
			joystick_position.x = get_local_mouse_position().x
			joystick_position.x = clamp(joystick_position.x, shape_rect.position.x, shape_rect.position.x + shape_rect.size.x)
		if vertical:
			joystick_position.y = get_local_mouse_position().y
			joystick_position.y = clamp(joystick_position.x, shape_rect.position.y, shape_rect.position.y + shape_rect.size.y)
	else:
		joystick_position = shape.get_rect().get_center()
	queue_redraw()


func _draw() -> void:
	draw_circle(joystick_position, 25, Color.RED)
