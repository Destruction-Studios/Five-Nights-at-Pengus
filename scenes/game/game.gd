extends Control
class_name Game

const GAME_BG = preload("res://assets/images/game/game_bg.png")
const GAME_BG_LIGHTOFF = preload("res://assets/images/game/game_bg_lightoff.png")

const BREATHING = preload("res://assets/audio/sound_effects/random_game_sounds/breathing.mp3")

const RANDOM_SOUNDS: Array[Resource] = [
	BREATHING, BREATHING, BREATHING, BREATHING,
	preload("res://assets/audio/sound_effects/random_game_sounds/cave.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/cave_2.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/door_creak.ogg"),
	preload("res://assets/audio/sound_effects/random_game_sounds/lamp_buzz.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/metal_door.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/trash_can_lid.mp3"),
]

const PENGU_SOUNDS: Array[Resource] = [
	preload("res://assets/audio/sound_effects/pengu/attention_spam.mp3"),
	preload("res://assets/audio/sound_effects/pengu/easy.mp3"),
	preload("res://assets/audio/sound_effects/pengu/gang_up.mp3"),
	preload("res://assets/audio/sound_effects/pengu/im_better.mp3"),
	preload("res://assets/audio/sound_effects/pengu/life_party.mp3"),
	preload("res://assets/audio/sound_effects/pengu/meatloaf.mp3"),
	preload("res://assets/audio/sound_effects/pengu/mmm.mp3"),
	preload("res://assets/audio/sound_effects/pengu/oh.mp3"),
	preload("res://assets/audio/sound_effects/pengu/soda_pop.mp3"),
	preload("res://assets/audio/sound_effects/pengu/soda_pop_2.mp3"),
	preload("res://assets/audio/sound_effects/pengu/stop.mp3"),
	preload("res://assets/audio/sound_effects/pengu/took_all_meatloaf.mp3"),
	preload("res://assets/audio/sound_effects/pengu/where_is_iron.mp3"),
	preload("res://assets/audio/sound_effects/pengu/YO.mp3"),
	preload("res://assets/audio/sound_effects/pengu/you_got_nothing.mp3"),
	preload("res://assets/audio/sound_effects/pengu/y_76.mp3"),
	preload("res://assets/audio/sound_effects/pengu/shenanigans.mp3"),
]

const PENGU_VISUALS = {
	Utils.PENGU_POSITIONS.WINDOW_RIGHT: preload("res://assets/images/game/pengu_visuals/pengu_window_right.png"),
	Utils.PENGU_POSITIONS.WINDOW_LEFT: preload("res://assets/images/game/pengu_visuals/pengu_window_left.png"),
	Utils.PENGU_POSITIONS.WINDOW_LEFT_LAY: preload("res://assets/images/game/pengu_visuals/pengu_window_left_lay.png"),
	Utils.PENGU_POSITIONS.DOOR: preload("res://assets/images/game/pengu_visuals/pengu_door.png")
}

const MENU = preload("res://scenes/menu/menu.tscn")
const WIN_SCREEN = preload("uid://dvnbsrvtdfuwf")
const MAP = preload("uid://c46r23oby0gq4")

@export var pengu_ai: PenguAI

@onready var time_label: Label = $GameUI/VBoxContainer/Time
@onready var sound_timer: Timer = $Timers/SoundTimer
@onready var random_sound: AudioStreamPlayer = $Sounds/RandomSound
@onready var light_timer: Timer = $Timers/LightTimer
@onready var cookie_label: Label = $GameUI/MarginContainer/CookieLabelCont/CookieLabel
@onready var cookie_timer: Timer = $Timers/CookieTimer
@onready var pengu_sound: AudioStreamPlayer = $Sounds/PenguSound
@onready var pengu_sound_timer: Timer = $Timers/PenguSoundTimer
@onready var locator_button: Button = $GameUI/MarginContainer/LocatorButton

var light_flickering = false

var is_game_over = false
var is_door_closed = false
var time = 0

var pengu_sound_range: FloatRange = FloatRange.new(2.0, 10.0)
var rand_sound_range: FloatRange = FloatRange.new(5.0, 22.0)
var flicker_range: FloatRange = FloatRange.new(1.5, 9.0)
var cookie_manager = CookieManager.new()

var available_pengu_sounds: Array[Resource] = PENGU_SOUNDS.duplicate()

var current_map: Map

func _ready() -> void:
	update_cookies()
	
	$Timers/GameDurationTimer.wait_time = GameSettings.GAME_DURATION_SECONDS
	$Timers/HourTimer.wait_time = GameSettings.HOUR_DURATION
	$Timers/GameDurationTimer.start()
	$Timers/HourTimer.start()
	
	sound_timer.start(rand_sound_range.rand())
	light_timer.start(flicker_range.rand())
	
	cookie_timer.start(GameSettings.COOKIE_LOSS_INVERVAL.rand())
	pengu_sound_timer.start(pengu_sound_range.rand())
	
	pengu_updated(pengu_ai.current_pos)

func game_over() -> void:
	is_game_over = true
	print("Game Over!")
	$Timers/HourTimer.stop()
	time = GameSettings.GAME_DURATION_HOURS
	game_hour_passed()
	
	cookie_timer.stop()
	pengu_sound_timer.stop()
	random_sound.stop()
	pengu_sound.stop()
	
	var win: WinScreen = WIN_SCREEN.instantiate()
	add_child(win)
	win.animation_finished.connect(func():
		print("Transition Back")
		Transitions.transition_to_file("res://scenes/menu/menu.tscn")
	)

func game_hour_passed() -> void:
	if is_game_over:
		return
	time += 1
	time_label.text = str(time) + ":00"
	$Sounds/ClockTickSound.play()
	print("Hour Passed, ", $Timers/GameDurationTimer.time_left, " left")

func pengu_updated(pos: Utils.PENGU_POSITIONS) -> void:
	var new_texture: Resource
	if PENGU_VISUALS.has(pos):
		print("Current Pengu Pos has visual")
		new_texture = PENGU_VISUALS.get(pos)
	
	$PenguVisual.texture = new_texture
	
	if current_map:
		current_map.update()

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
	light_timer.wait_time = randf_range(.05, 1)
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
	if available_pengu_sounds.is_empty():
		print("Empty sounds, replacing")
		available_pengu_sounds = PENGU_SOUNDS.duplicate()
	print("Pengu speak")
	var randomInt := randi_range(0, available_pengu_sounds.size()-1)
	pengu_sound.stream = available_pengu_sounds[randomInt]
	pengu_sound.play()
	
	available_pengu_sounds.remove_at(randomInt)
	
	await pengu_sound.finished
	pengu_sound_timer.start(pengu_sound_range.rand())


func _on_locator_button_mouse_entered() -> void:
	if current_map == null:
		var inst: Map = MAP.instantiate()
		inst.pengu_ai = pengu_ai
		add_child(inst)
		current_map = inst
	elif current_map != null:
		current_map.queue_free()
		current_map = null


func _on_pengu_ai_position_updated() -> void:
	pengu_updated(pengu_ai.current_pos)
