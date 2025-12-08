extends Control
class_name WinScreen

signal animation_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var after_timer: Timer = $AfterTimer

func _ready() -> void:
	$AnimatedSprite2D.play()
	animation_player.play("default")
	await animation_player.animation_finished
	after_timer.start()
	await after_timer.timeout
	animation_finished.emit()
