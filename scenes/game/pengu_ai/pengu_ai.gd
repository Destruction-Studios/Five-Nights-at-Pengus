extends Node
class_name PenguAI

signal position_updated

@export var game: Game

@onready var move_timer: Timer = $MoveTimer

var current_pos: Utils.PENGU_POSITIONS = Utils.PENGU_POSITIONS.START

var move_time_range: FloatRange = FloatRange.new(2.0, 6.0)

func _ready() -> void:
	move_timer.start(move_time_range.rand())

func move() -> void:
	var next_pos
	if current_pos == Utils.PENGU_POSITIONS.CROSSROADS:
		if randi_range(1, GameSettings.BEHIND_CHANCE) == 1:
			next_pos = Utils.PENGU_POSITIONS.RIGHT_HALLWAY
		else:
			next_pos = Utils.PENGU_POSITIONS.WINDOW_RIGHT
	elif current_pos == Utils.PENGU_POSITIONS.DOOR or current_pos == Utils.PENGU_POSITIONS.ROOM_BEHIND:
		print("GAME OVER :(")
		return
	else:
		next_pos = Utils.get_next_pengu_pos(current_pos)
	
	print("Pengu moved: ", next_pos)
	
	current_pos = next_pos
	position_updated.emit()


func disable_move() -> void:
	pass


func try_move() -> bool:
	print("Try move")
	if !randi_range(1, GameSettings.MOVE_CHANCE) == 1: return false
	if game.is_door_closed and current_pos == Utils.PENGU_POSITIONS.DOOR: return false
	move()
	return true

func _on_move_timer_timeout() -> void:
	Transitions.blink()
	await Transitions.blink_halfway
	var success = try_move()
	if success: 
		move_timer.start(move_time_range.rand() * 2.0)
	else:
		move_timer.start(move_time_range.rand())
