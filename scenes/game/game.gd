extends Control



const GAME_BG = preload("uid://bofhtac8n6os5")
const GAME_BG_LIGHTOFF = preload("uid://bs8sy2ahyfbx1")

const MIN_SOUND_TIME: float = 5.0
const MAX_SOUND_TIME: float = 22.0



const RANDOM_SOUNDS: Array[Resource] = [
	preload("res://assets/audio/sound_effects/random_game_sounds/cave.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/cave_2.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/door_creak.ogg"),
	preload("res://assets/audio/sound_effects/random_game_sounds/lamp_buzz.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/metal_door.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/trash_can_lid.mp3"),
]
@onready var time_label: Label = $GameUI/VBoxContainer/Time
@onready var sound_timer: Timer = $SoundStuff/SoundTimer
@onready var random_sound: AudioStreamPlayer = $SoundStuff/RandomSound
@onready var light_timer: Timer = $LightTimer

var light_flickering = false

var is_game_over = false
var time = 0

var soundRange: FloatRange = FloatRange.new(5.0, 22.0)
var flickerRange: FloatRange = FloatRange.new(1.5, 9.0)

func _ready() -> void:
	$GameDurationTimer.wait_time = GameSettings.GAME_DURATION_SECONDS
	$HourTimer.wait_time = GameSettings.HOUR_DURATION
	$GameDurationTimer.start()
	$HourTimer.start()
	
	sound_timer.start(soundRange.rand())
	light_timer.start(flickerRange.rand())

func game_over() -> void:
	is_game_over = true
	print("Game Over!")
	$HourTimer.stop()
	game_hour_passed()

func game_hour_passed() -> void:
	if is_game_over:
		return
	time += 1
	time_label.text = str(time) + ":00"
	$SoundStuff/ClockTickSound.play()
	print("Hour Passed, ", $GameDurationTimer.time_left, " left")

func _on_game_duration_timer_timeout() -> void:
	game_over()


func _on_hour_timer_timeout() -> void:
	game_hour_passed()


func _on_sound_timer_timeout() -> void:
	print("Play rand sound")
	random_sound.stream = RANDOM_SOUNDS[randi_range(0, RANDOM_SOUNDS.size() - 1)]
	random_sound.play()
	await random_sound.finished
	sound_timer.start(randf_range(MIN_SOUND_TIME, MAX_SOUND_TIME))


func _on_light_timer_timeout() -> void:
	if light_flickering:
		return
	print("Flicker")
	light_flickering = true
	$Background.texture = GAME_BG_LIGHTOFF
	$SoundStuff/FlickerSound.play()
	light_timer.wait_time = randf_range(.01, .1)
	light_timer.start()
	await light_timer.timeout
	$Background.texture = GAME_BG
	light_flickering = false
	light_timer.start(flickerRange.rand())
