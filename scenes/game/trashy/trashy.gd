extends Control
class_name Trashy

signal moved(stage: int)

var VISUALS = {
	str(1): preload("res://assets/images/game/trashy_visuals/stage_1.png"),
	str(2): preload("res://assets/images/game/trashy_visuals/stage_2.png"),
	str(3): preload("res://assets/images/game/trashy_visuals/stage_3.png"),
	str(4): preload("res://assets/images/game/trashy_visuals/stage_4.png"),
	
	str(99): preload("res://assets/images/game/trashy_visuals/trashy_out_sign.png")
}

@onready var move_timer: Timer = $MoveTimer
@onready var visual: TextureRect = $Visual

var is_out = false

var can_move = false

var default_stage: int = 1
var stage: int = 1

func _ready() -> void:
	update_stage()

func start_attacking() -> void:
	print("Trashy Enemy Out")

func update_stage() -> void:
	var new_nexture = VISUALS.get(str(stage))
	visual.texture = new_nexture


func go_away() -> bool:
	if is_out: return false
	
	#Transitions.blink()
	#await Transitions.blink_halfway
	if stage == default_stage: return false
	stage = max(default_stage, stage - 1)
	print("Trashy Stage: ", stage)
	update_stage()
	
	return true

func enable_moving() -> void:
	can_move = true
	try_move()
	move_timer.start(GameSettings.TRASHY_COOLDOWN.rand())

func disable_moving() -> void:
	can_move = false
	move_timer.stop()

func try_move() -> bool:
	if !can_move or is_out: return false
	print("trashy trying to move")
	if randi_range(1, GameSettings.TRASHY_CHANCE) != 1:
		return false
	print("Trashy moving!")
	
	if stage >= 4:
		is_out = true
		stage = 99
		default_stage = 99
		update_stage()
		start_attacking()
		$Out.play()
		return false
	
	
	stage += 1
	update_stage()
	moved.emit(stage)
	
	default_stage = max(stage - 1, 1)
	
	return true

func _on_move_timer_timeout() -> void:
	var success = try_move()
	var multi = 0.0
	if success: multi = 1.75
	move_timer.start(GameSettings.TRASHY_COOLDOWN.rand() * multi)
