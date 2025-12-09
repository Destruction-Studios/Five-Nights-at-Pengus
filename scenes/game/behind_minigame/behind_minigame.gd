extends Control
class_name StarvingMinigame

signal minigame_completed(success: bool)

const LERP_INTERP = 7.0

@onready var music: AudioStreamPlayer = $Music
@onready var circle: Circle = $Circle
@onready var mouse_circle: Circle = $MouseCircle
@onready var progress_bar: ProgressBar = $Progress

var time_to_start_at = 0
var circle_radius
var target_pos = Vector2.ZERO
var current_pos = target_pos

var progress: float = GameSettings.START_PROGRESS

var is_bumped = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	#time_to_start_at = max(0, music.stream.get_length() - GameSettings.MINIGAME_DURATION)
	music.play()#(time_to_start_at)
	
	circle.circle_position = get_viewport_rect().size/2
	mouse_circle.circle_position = get_global_mouse_position()
	target_pos = circle.circle_position
	current_pos = circle.circle_position
	
	Input.warp_mouse(current_pos)
	
	$BumpTimer.start(.05)
	$GameTimer.start(GameSettings.MINIGAME_DURATION)
	
	update_progress()


func _process(delta: float) -> void:
	if Input.is_key_label_pressed(KEY_ESCAPE):
		get_tree().quit()
	current_pos = lerp(current_pos, target_pos, LERP_INTERP * delta)
	
	mouse_circle.circle_position = current_pos
	mouse_circle.queue_redraw()
	
	var distance = circle.circle_position.distance_to(current_pos)
	#print(distance)
	if distance > circle.radius:
		progress -= GameSettings.PROGRESS_DECREASE * delta
	else:
		progress += GameSettings.PROGRESS_INCREASE * delta
	
	update_progress()

func update_progress() -> void:
	progress = clampf(progress, 0.0, 100.0)
	progress_bar.value = progress
	
	minigame_completed.emit(!progress <= 0.0)

func _input(event: InputEvent) -> void:
	if is_bumped: 
		is_bumped = false 
		return
	if !event is InputEventMouseMotion:
		return
	target_pos += event.relative


func _on_bump_timer_timeout() -> void:
	is_bumped = true
	target_pos += Vector2(
		randf_range(-GameSettings.BUMP_OFFSET.x, GameSettings.BUMP_OFFSET.x),
		randf_range(-GameSettings.BUMP_OFFSET.y, GameSettings.BUMP_OFFSET.y)
	)
	Input.warp_mouse(target_pos)
	$BumpTimer.start(GameSettings.BUMP_RANGE.rand())


func _on_game_timer_timeout() -> void:
	#minigame_completed.emit(true)
	pass
