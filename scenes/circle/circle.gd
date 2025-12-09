extends Control
class_name Circle

@export var circle_position: Vector2
@export var radius: float = 50
@export var color: Color = Color.WHITE
@export var thickness: float = 4
@export var filled: bool = false

func _draw() -> void:
	if !filled:
		draw_circle(circle_position, radius, color, filled, thickness)
	else:
		draw_circle(circle_position, radius, color, filled)
