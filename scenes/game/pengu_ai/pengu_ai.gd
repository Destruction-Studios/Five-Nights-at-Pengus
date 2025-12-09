extends Node
class_name PenguAI

signal position_updated

@export var game: Game
@export var cookie_controller: CookieController

@onready var move_timer: Timer = $MoveTimer
@onready var attack_timer: Timer = $AttackTimer

var current_pos: Utils.PENGU_POSITIONS = Utils.PENGU_POSITIONS.ROOM_BEHIND
var move_time_range: FloatRange = FloatRange.new(GameSettings.MIN_MOVE_TIME, GameSettings.MAX_MOVE_TIME)

var has_been_fed: bool = false

func _ready() -> void:
	move_timer.start(move_time_range.rand())
	cookie_controller.cookies_updated.connect(cookies_updated)

func stop() -> void:
	pass

#func get_next_pos() -> Utils.PENGU_POSITIONS:
	##var current_path_data: Dictionary = Utils.AI_PATHS[current_pos]
##
	##var max_value := 0
	##for v in current_path_data.values():
		##max_value = maxi(max_value, v)
##
	##var total_weight := 0
	##var inverted := {}
	##for key in current_path_data:
		##var inv = (max_value + 1) - current_path_data[key]
		##inverted[key] = inv
		##total_weight += inv
##
	##var roll := randi_range(1, total_weight)
##
	##var running := 0
	##var winner
	##for key in inverted:
		##running += inverted[key]
		##if roll <= running:
			##winner = key
	#
	#var paths: Dictionary = Utils.AI_PATHS[current_pos]
	#
	#var max_value := 0
	#var entries := []
	#
	#for key in paths:
		#var v = paths[key]
		#max_value = maxi(max_value, v)
		#entries.append({ "key": key, "value": v })
	#
	#print(entries)
	#
	#var total_weight := 0
	#for e in entries:
		#e.inv = max(1, (max_value + 1) - e.value)
		#total_weight += e.inv
	#
	#print(total_weight)
	#
	#var roll := randi_range(1, total_weight)
	#var running := 0
	#
	#print("R:", roll)
	#
	#var winner
	#for e in entries:
		#print(e)
		#running += e.inv
		#print("RG ", running)
		#if roll <= running:
			#winner =  e.value
	#
	#if !winner:
		#push_error("Unable to get next pos")
		#return current_pos
	#
	#print("New Pos: ", Utils.PENGU_POSITIONS.find_key(winner))
	#
	#return winner

func get_next_pos() -> Utils.PENGU_POSITIONS:
	var paths: Dictionary = Utils.AI_PATHS[current_pos]
	
	if paths.size() == 1:
		return paths.keys()[0]
	
	var total := 0
	for w in paths.values():
		total += w
	
	var r := randi_range(0, total - 1)
	
	var keys := paths.keys()
	keys.shuffle()
	
	var running := 0
	for key in keys:
		running += paths[key]
		if r < running:
			return key
	
	return current_pos


func move(new_pos: Utils.PENGU_POSITIONS) -> void:
	if new_pos == Utils.PENGU_POSITIONS.START:
		has_been_fed = true
	
	print("Pengu moved to: ", Utils.PENGU_POSITIONS.find_key(new_pos))
	
	current_pos = new_pos
	position_updated.emit()

func reach_player() -> void:
	game.jumpscare()

func will_jumpscare() -> bool:
	if current_pos == Utils.PENGU_POSITIONS.DOOR or current_pos == Utils.PENGU_POSITIONS.ROOM_BEHIND: return true
	return false

func try_move() -> void:
	var next_pos = get_next_pos()
	if next_pos == Utils.PENGU_POSITIONS.PLAYER:
		if current_pos == Utils.PENGU_POSITIONS.ROOM_BEHIND or current_pos == Utils.PENGU_POSITIONS._RBH_ALT:
			print("Do Minigame")
			
			cookie_controller.paused = true
			
			move(Utils.PENGU_POSITIONS.TABLE)
			var success = await game.start_minigame()
			if !success: return
			Transitions.blink()
			await Transitions.blink_halfway
			move(Utils.PENGU_POSITIONS.START)
			cookie_controller.paused = false
		else:
			attack_timer.start(GameSettings.ATTACK_DELAY.rand())
			await attack_timer.timeout
		
			var can_attack = true
			if current_pos == Utils.PENGU_POSITIONS.DOOR and game.is_door_closed:
				can_attack = false
			
			if !can_attack: 
				Transitions.blink()
				await Transitions.blink_halfway
				move(Utils.PENGU_POSITIONS.START)
				#TODO make it no delay in hard
				move_timer.start(move_time_range.rand())
				return
			
			game.jumpscare()
			return
	if !randi_range(1, GameSettings.MOVE_CHANCE) == 1:
		move_timer.start(move_time_range.rand())
		return
	Transitions.blink()
	await Transitions.blink_halfway
	move(next_pos)
	move_timer.start(move_time_range.rand() * GameSettings.MOVE_SUCCESS_TIME_MULTI)

func _on_move_timer_timeout() -> void:
	try_move()

func feed(amount: int) -> void:
	has_been_fed = true
	cookie_controller.add_cookies(amount)


func cookies_updated(cookies: int) -> void:
	print("Pengu has ", cookies, " cookies")
	if cookies <= 0:
		if !$Starving.playing: $Starving.play()
	if cookies <= 4:
		if !$Hungry.playing: $Hungry.play()
	else:
		$Hungry.stop()
