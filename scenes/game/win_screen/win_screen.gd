extends Control
class_name WinScreen

signal animation_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var after_timer: Timer = $AfterTimer

func _ready() -> void:
	animation_player.play("default")
	await animation_player.animation_finished
	after_timer.start()
	await after_timer.timeout
	#SceneFade.transition_to_scene(next_scene)
	animation_finished.emit()
