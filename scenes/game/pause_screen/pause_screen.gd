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
