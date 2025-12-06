extends Control

const GAME = preload("uid://b7ypfeo8f3h3y")

func _on_play_button_down() -> void:
	SceneFade.transition_to_scene(GAME)
