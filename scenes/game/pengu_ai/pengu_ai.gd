extends Node
class_name PenguAI

signal position_updated

@export var game: Game
@export var cookie_controller: CookieController

@onready var move_timer: Timer = $MoveTimer
@onready var attack_timer: Timer = $AttackTimer

var current_pos: Utils.PENGU_POSITIONS = Utils.PENGU_POSITIONS.ROOM_BEHIND

var has_been_fed: bool = false

func _ready() -> void:
	move_timer.start(GameSettings.MOVE_TIME.rand())
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
	
	print("Paths from ", Utils.PENGU_POSITIONS.find_key(current_pos), ": ", paths)
	
	if current_pos == Utils.PENGU_POSITIONS.PLAYER:
		return Utils.PENGU_POSITIONS.PLAYER
	
	if paths.size() == 1:
		print("return single")
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
	game.jumpscare(Jumpscare.JUMPSCARE_TYPES.PENGU)

func will_jumpscare() -> bool:
	if current_pos == Utils.PENGU_POSITIONS.DOOR or current_pos == Utils.PENGU_POSITIONS.ROOM_BEHIND: return true
	return false

func do_blink() -> void:
	Transitions.blink()
	await Transitions.blink_halfway

func start_move_timer(multi: float = 1.0) -> void:
	move_timer.start(GameSettings.MOVE_TIME.rand() * multi)

func try_move() -> void:
	var next_pos = get_next_pos()

	# DOOR MOVE
	#if next_pos == Utils.PENGU_POSITIONS.DOOR:
		#await do_blink()
		#move(next_pos)
		#start_move_timer(0.5)
		#return

	# PLAYER MOVE
	if next_pos == Utils.PENGU_POSITIONS.PLAYER:
		print("To Player, waiting")
		#var delay = GameSettings.ATTACK_DELAY.rand()
		#attack_timer.start(delay)
		#await attack_timer.timeout
		
		var new_pos = Utils.PENGU_POSITIONS.START
		if current_pos == Utils.PENGU_POSITIONS.DOOR:
			if randi_range(1, 2) == 1:
				new_pos = Utils.PENGU_POSITIONS._RL_ALT
		
		var can_attack := !(current_pos == Utils.PENGU_POSITIONS.DOOR and game.is_door_closed)
		if !can_attack:
			await do_blink()
			move(new_pos)
			start_move_timer()
			return

		reach_player()
		return

	# TABLE (Minigame)
	if next_pos == Utils.PENGU_POSITIONS.TABLE:
		if game.is_bag_down:
			var i: float = 0.0
			var start_minigame = false
			while i < GameSettings.BAG_WAIT:
				if !game.is_bag_down:
					start_minigame = true
					break
				await get_tree().create_timer(.1).timeout
				i += 0.1
			if !start_minigame:
				await do_blink()
				move(Utils.PENGU_POSITIONS.START)
				start_move_timer(0.5)
				return
		
		cookie_controller.paused = true
		print("Starting minigame from: ", Utils.PENGU_POSITIONS.find_key(current_pos))
		move(Utils.PENGU_POSITIONS.TABLE)

		var success = await game.start_minigame()
		if !success:
			return

		await do_blink()
		move(Utils.PENGU_POSITIONS.START)
		start_move_timer()
		cookie_controller.paused = false
		return

	# RANDOM MOVE CHANCE
	if randi_range(1, GameSettings.MOVE_CHANCE) != 1:
		await do_blink()
		start_move_timer()
		return
	
	var multi: float = 1.0
	if next_pos == Utils.PENGU_POSITIONS.DOOR:
		multi = 0.75
	
	# DEFAULT MOVE
	await do_blink()
	move(next_pos)
	start_move_timer(multi)

func _on_move_timer_timeout() -> void:
	print("Try Move")
	try_move()

func feed(amount: int) -> void:
	has_been_fed = true
	cookie_controller.add_cookies(amount)


func cookies_updated(_cookies: int) -> void:
	pass
	#print("Pengu has ", cookies, " cookies")
	#if cookies <= 0:
		#if !$Starving.playing: $Starving.play()
	#if cookies <= 4:
		#if !$Hungry.playing: $Hungry.play()
	#else:
		#$Hungry.stop()
