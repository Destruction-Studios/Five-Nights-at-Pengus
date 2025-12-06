extends Node

const HAND_OPEN = preload("uid://rlfwhibwmex0")
const HAND_CLOSED = preload("uid://c8qkkjjo1giut")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			Input.set_custom_mouse_cursor(HAND_CLOSED)
		else:
			Input.set_custom_mouse_cursor(HAND_OPEN)
