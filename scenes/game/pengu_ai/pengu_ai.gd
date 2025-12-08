extends Node
class_name PenguAI

signal pengu_moved

@onready var move_timer: Timer = $MoveTimer

var move_time_range: FloatRange = FloatRange.new(2.0, 5.0)

func _ready() -> void:
	move_timer.start(move_time_range.rand())

func disable_move():
	pass

func try_move():
	pass


func _on_move_timer_timeout() -> void:
	try_move()
