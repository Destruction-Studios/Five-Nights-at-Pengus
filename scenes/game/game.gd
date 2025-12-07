extends Control

const GAME_BG = preload("uid://bofhtac8n6os5")
const GAME_BG_LIGHTOFF = preload("uid://bs8sy2ahyfbx1")

const RANDOM_SOUNDS: Array[Resource] = [
	preload("res://assets/audio/sound_effects/random_game_sounds/cave.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/cave_2.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/door_creak.ogg"),
	preload("res://assets/audio/sound_effects/random_game_sounds/lamp_buzz.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/metal_door.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/trash_can_lid.mp3"),
]

var PENGU_SOUNDS: Array[Resource] = []

@onready var time_label: Label = $GameUI/VBoxContainer/Time
@onready var sound_timer: Timer = $Timers/SoundTimer
@onready var random_sound: AudioStreamPlayer = $Sounds/RandomSound
@onready var light_timer: Timer = $Timers/LightTimer
@onready var cookie_label: Label = $GameUI/MarginContainer/CookieLabelCont/CookieLabel
@onready var cookie_timer: Timer = $Timers/CookieTimer
@onready var pengu_sound: AudioStreamPlayer = $Sounds/PenguSound
@onready var pengu_sound_timer: Timer = $Timers/PenguSoundTimer

var light_flickering = false

var is_game_over = false
var time = 0

var pengu_sound_range: FloatRange = FloatRange.new(1, 3)
var rand_sound_range: FloatRange = FloatRange.new(5.0, 22.0)
var flicker_range: FloatRange = FloatRange.new(1.5, 9.0)
var cookie_manager = CookieManager.new()

func _ready() -> void:
	PENGU_SOUNDS = Utils.load_all(Utils.get_all_in_dir("res://assets/audio/sound_effects/pengu/"))
	update_cookies()
	
	$Timers/GameDurationTimer.wait_time = GameSettings.GAME_DURATION_SECONDS
	$Timers/HourTimer.wait_time = GameSettings.HOUR_DURATION
	$Timers/GameDurationTimer.start()
	$Timers/HourTimer.start()
	
	sound_timer.start(rand_sound_range.rand())
	light_timer.start(flicker_range.rand())
	
	cookie_timer.start(GameSettings.COOKIE_LOSS_INVERVAL.rand())
	pengu_sound_timer.start(pengu_sound_range.rand())

func game_over() -> void:
	is_game_over = true
	print("Game Over!")
	$Timers/HourTimer.stop()
	time = GameSettings.GAME_DURATION_HOURS
	game_hour_passed()

func game_hour_passed() -> void:
	if is_game_over:
		return
	time += 1
	time_label.text = str(time) + ":00"
	$Sounds/ClockTickSound.play()
	print("Hour Passed, ", $Timers/GameDurationTimer.time_left, " left")

func update_cookies() -> void:
	cookie_label.text = ": " + str(cookie_manager.get_cookies())

func _on_game_duration_timer_timeout() -> void:
	game_over()


func _on_hour_timer_timeout() -> void:
	game_hour_passed()


func _on_sound_timer_timeout() -> void:
	print("Play rand sound")
	random_sound.stream = RANDOM_SOUNDS.pick_random()
	random_sound.play()
	await random_sound.finished
	sound_timer.start(rand_sound_range.rand())


func _on_light_timer_timeout() -> void:
	if light_flickering:
		return
	print("Flicker")
	light_flickering = true
	$Background.texture = GAME_BG_LIGHTOFF
	$Sounds/FlickerSound.play()
	light_timer.wait_time = randf_range(.01, .1)
	light_timer.start()
	await light_timer.timeout
	$Background.texture = GAME_BG
	light_flickering = false
	light_timer.start(flicker_range.rand())


func _on_cookie_timer_timeout() -> void:
	if is_game_over:
		return
	cookie_manager.remove_cookie()
	update_cookies()
	cookie_timer.start(GameSettings.COOKIE_LOSS_INVERVAL.rand())


func _on_pengu_sound_timer_timeout() -> void:
	print("Pengu speak")
	pengu_sound.stream = PENGU_SOUNDS.pick_random()
	pengu_sound.play()
	await pengu_sound.finished
	pengu_sound_timer.start(pengu_sound_range.rand())
