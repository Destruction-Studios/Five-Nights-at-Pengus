extends Control
class_name WinScreen

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var after_timer: Timer = $AfterTimer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	$AnimatedSprite2D.play()
	animation_player.play("default")
	await animation_player.animation_finished
	after_timer.start()
	await after_timer.timeout
	Transitions.transition_to_file("res://scenes/menu/menu.tscn")
