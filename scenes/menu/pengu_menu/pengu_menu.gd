extends Control

const HEAD_TILTED = preload("uid://binrqg5wk78g7")
const NORMAL = preload("uid://rhbsd5xu0je")
const HEAD_TILTED_RIGHT = preload("uid://by8sqjsxo2tix")
const FACE_SAD = preload("uid://cmxecwl5psxmp")
const JUMP = preload("uid://br2ug6smcuu2j")

const MOVE_IMAGES: Array[Resource] = [HEAD_TILTED, HEAD_TILTED_RIGHT, FACE_SAD, JUMP]

const CHANGE_MIN = .2
const CHANGE_MAX = 2.0

const CHANGE_BACK_MIN = .06
const CHANGE_BACK_MAX = .1

@onready var main_change: Timer = $MainChangeTimer
@onready var change_back_timer: Timer = $ChangeBackTimer


func _ready() -> void:
	run_timer()

func run_timer() -> void:
	main_change.start(randf_range(CHANGE_MIN, CHANGE_MAX))


func _on_main_change_timer_timeout() -> void:
	print("Change")
	var randResource: Resource = MOVE_IMAGES[randi_range(0, MOVE_IMAGES.size() - 1)]
	self.texture = randResource
	change_back_timer.start(randf_range(CHANGE_BACK_MIN, CHANGE_BACK_MAX))
	await change_back_timer.timeout
	self.texture = NORMAL
	run_timer()
