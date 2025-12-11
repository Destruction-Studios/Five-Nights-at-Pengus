extends Control

const HEAD_TILTED = preload("uid://binrqg5wk78g7")
const NORMAL = preload("uid://rhbsd5xu0je")
const HEAD_TILTED_RIGHT = preload("uid://by8sqjsxo2tix")
const FACE_SAD = preload("uid://cmxecwl5psxmp")
const JUMP = preload("uid://br2ug6smcuu2j")

const MOVE_IMAGES: Array[Resource] = [HEAD_TILTED, HEAD_TILTED_RIGHT, FACE_SAD, JUMP]

var changeRange: FloatRange = FloatRange.new(.2, 2.0)
var changeBackRange: FloatRange = FloatRange.new(.06, .1)

@onready var main_change: Timer = $MainChangeTimer
@onready var change_back_timer: Timer = $ChangeBackTimer


func _ready() -> void:
	run_timer()

func run_timer() -> void:
	main_change.start(changeRange.rand())


func _on_main_change_timer_timeout() -> void:
	var randResource: Resource = MOVE_IMAGES.pick_random()
	self.texture = randResource
	change_back_timer.start(changeBackRange.rand())
	await change_back_timer.timeout
	self.texture = NORMAL
	run_timer()
