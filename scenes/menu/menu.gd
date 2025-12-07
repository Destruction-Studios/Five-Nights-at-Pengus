extends Control

@onready var button_sound: AudioStreamPlayer = $ButtonSound

func _on_play_button_down() -> void:
	SceneFade.transition_to_file("res://scenes/game/game.tscn")
	button_sound.play()
