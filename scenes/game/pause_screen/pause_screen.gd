extends Control

func _ready() -> void:
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		get_tree().paused = false
		SceneFade.transition_to_file("res://scenes/menu/menu.tscn")
	elif event.is_action_pressed("unpause"):
		print("Unpausing")
		get_tree().paused = false
		queue_free()


func _on_button_button_down() -> void:
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false);
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
