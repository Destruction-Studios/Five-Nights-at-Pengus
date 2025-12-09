extends Control

@onready var button_sound: AudioStreamPlayer = $ButtonSound

func _on_play_button_down() -> void:
	Transitions.transition_to_file("res://scenes/game/game.tscn")
	button_sound.play()
	


func _on_fullscreen_button_down() -> void:
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false);
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
