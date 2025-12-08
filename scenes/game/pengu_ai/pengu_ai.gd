extends Node
class_name PenguAI

signal position_updated
signal cookies_updated

@export var game: Game

@onready var move_timer: Timer = $MoveTimer

var current_pos: Utils.PENGU_POSITIONS = Utils.PENGU_POSITIONS.START
var move_time_range: FloatRange = FloatRange.new(GameSettings.MIN_MOVE_TIME, GameSettings.MAX_MOVE_TIME)

var my_cookies: int = GameSettings.PENGU_START_COOKIES
var has_been_fed: bool = false

func _ready() -> void:
	move_timer.start(move_time_range.rand())

func stop() -> void:
	pass

func move(to_start: bool = false) -> void:
	var next_pos
	if to_start:
		has_been_fed = false
		next_pos = Utils.PENGU_POSITIONS.START
	elif current_pos == Utils.PENGU_POSITIONS.CROSSROADS:
		if randi_range(1, GameSettings.BEHIND_CHANCE) == 1:
			next_pos = Utils.PENGU_POSITIONS.RIGHT_HALLWAY
		else:
			next_pos = Utils.PENGU_POSITIONS.WINDOW_RIGHT
	elif will_jumpscare():
		reach_player()
		return
	else:
		next_pos = Utils.get_next_pengu_pos(current_pos)
	
	my_cookies -= 1
	my_cookies_updated()
	
	print("Pengu moved: ", next_pos)
	
	current_pos = next_pos
	position_updated.emit()

func reach_player() -> void:
	game.lost_game()

func will_jumpscare() -> bool:
	if current_pos == Utils.PENGU_POSITIONS.DOOR or current_pos == Utils.PENGU_POSITIONS.ROOM_BEHIND: return true
	return false

func try_move() -> bool:
	print("Try move")
	if game.is_door_closed and current_pos == Utils.PENGU_POSITIONS.DOOR: return false
	if !randi_range(1, GameSettings.MOVE_CHANCE) == 1: return false
	move()
	return true

func _on_move_timer_timeout() -> void:
	var success
	if will_jumpscare():
		if current_pos == Utils.PENGU_POSITIONS.DOOR and game.is_door_closed:
			$MoveTimer.start(GameSettings.MOVE_TO_START_DELAY.rand())
			await $MoveTimer.timeout
			Transitions.blink()
			await Transitions.blink_halfway
			move(true)
			success = false
		if randi_range(1, GameSettings.ATTACK_CHANCE) == 1:
			print("Moving, ignoring timer")
			move()
			return
		else:
			success = false
	else:
		Transitions.blink()
		await Transitions.blink_halfway
		success = try_move()
	
	if success: 
		move_timer.start(move_time_range.rand() * 2.0)
	else:
		move_timer.start(move_time_range.rand())


func my_cookies_updated() -> void:
	print("Pengu has ", my_cookies, " cookies")
	if my_cookies <= 0:
		if !$Starving.playing: $Starving.play()
	if my_cookies <= 4:
		if !$Hungry.playing: $Hungry.play()
	else:
		$Hungry.stop()
	cookies_updated.emit()

func feed(amount: int) -> void:
	has_been_fed = true
	my_cookies += amount
	my_cookies_updated()
