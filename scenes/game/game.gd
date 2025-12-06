extends Control

const MIN_SOUND_TIME: int = 5
const MAX_SOUND_TIME: int = 22

const RANDOM_SOUNDS: Array[Resource] = [
	preload("res://assets/audio/sound_effects/random_game_sounds/cave.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/cave_2.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/door_creak.ogg"),
	preload("res://assets/audio/sound_effects/random_game_sounds/lamp_buzz.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/metal_door.mp3"),
	preload("res://assets/audio/sound_effects/random_game_sounds/trash_can_lid.mp3"),
]

@onready var time_label: Label = $GameUI/VBoxContainer/Time
@onready var sound_timer: Timer = $SoundTimer
@onready var random_sound: AudioStreamPlayer = $RandomSound

var is_game_over = false
var time = 0

func _ready() -> void:
	$GameDurationTimer.wait_time = GameSettings.GAME_DURATION_SECONDS
	$HourTimer.wait_time = GameSettings.HOUR_DURATION
	$GameDurationTimer.start()
	$HourTimer.start()
	
	sound_timer.start(randi_range(MIN_SOUND_TIME, MAX_SOUND_TIME))

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
	$ClockTick.play()
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
	sound_timer.start(randi_range(MIN_SOUND_TIME, MAX_SOUND_TIME))
