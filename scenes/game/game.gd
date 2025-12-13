extends Control
class_name Game

const GAME_BG = preload("res://assets/images/game/game_bg.png")
const GAME_BG_LIGHTOFF = preload("res://assets/images/game/game_bg_lightoff.png")

const PROGRESS_FILLED_WHITE = preload("uid://cm1t2qo1xkex3")
const PROGRESS_FILLED_RED = preload("uid://cxcadu4o5po31")

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
	#preload("res://assets/audio/sound_effects/pengu/soda_pop_2.mp3"),
	preload("res://assets/audio/sound_effects/pengu/stop.mp3"),
	preload("res://assets/audio/sound_effects/pengu/took_all_meatloaf.mp3"),
	preload("res://assets/audio/sound_effects/pengu/where_is_iron.mp3"),
	preload("res://assets/audio/sound_effects/pengu/YO.mp3"),
	preload("res://assets/audio/sound_effects/pengu/you_got_nothing.mp3"),
	preload("res://assets/audio/sound_effects/pengu/y_76.mp3"),
	preload("res://assets/audio/sound_effects/pengu/shenanigans.mp3"),
	preload("res://assets/audio/sound_effects/pengu/no_chest.mp3"),
	preload("res://assets/audio/sound_effects/pengu/off_my_meds.mp3"),
	preload("res://assets/audio/sound_effects/pengu/my_fortress.mp3"),
	preload("res://assets/audio/sound_effects/pengu/cant_do_this.mp3"),
	preload("res://assets/audio/sound_effects/pengu/what_are_you_doing.mp3"),
	preload("res://assets/audio/sound_effects/pengu/your_nasty.mp3"),
	preload("res://assets/audio/sound_effects/pengu/huh.mp3")
]

const PENGU_VISUALS = {
	Utils.PENGU_POSITIONS.WINDOW_RIGHT: preload("res://assets/images/game/pengu_visuals/pengu_window_right.png"),
	Utils.PENGU_POSITIONS.WINDOW_LEFT: preload("res://assets/images/game/pengu_visuals/pengu_window_left_new.png"),
	Utils.PENGU_POSITIONS.WINDOW_LEFT_LAY: preload("res://assets/images/game/pengu_visuals/pengu_window_left_lay.png"),
	Utils.PENGU_POSITIONS.DOOR: preload("res://assets/images/game/pengu_visuals/pengu_door.png"),
	Utils.PENGU_POSITIONS.TABLE: preload("res://assets/images/game/pengu_visuals/pengu_table.png"),
}

const MENU = preload("res://scenes/menu/menu.tscn")
const WIN_SCREEN = preload("uid://dvnbsrvtdfuwf")
const MAP = preload("uid://c46r23oby0gq4")
const BEHIND_MINIGAME = preload("uid://dmdpvvlx8kuo2")
const PAUSE_SCREEN = preload("uid://b7vjkiyy0e5io")
const JUMPSCARE = preload("uid://044jkvm4t1b7")
const COOKIE_MAKER = preload("uid://q6xblmvrg2u7")

@export var pengu_ai: PenguAI
@export var cookie_controller: CookieController
@export var trashy: Trashy
@export var jackson_ai: JacksonAI

@onready var time_label: Label = $GameUI/VBoxContainer/Time
@onready var sound_timer: Timer = $Timers/SoundTimer
@onready var random_sound: AudioStreamPlayer = $Sounds/RandomSound
@onready var light_timer: Timer = $Timers/LightTimer
@onready var pengu_cookie_label: Label = $GameUI/MarginContainer/VBoxContainer/PenguCookies/PenguCookieLabel
@onready var cookie_label: Label = $GameUI/MarginContainer/VBoxContainer/CookieLabelCont/CookieLabel
@onready var pengu_sound: AudioStreamPlayer = $Sounds/PenguSound
@onready var pengu_sound_timer: Timer = $Timers/PenguSoundTimer
@onready var locator_button: Button = $GameUI/MarginContainer/LocatorButton
@onready var feed_button: Button = $GameUI/FeedButton
@onready var air_progress: ProgressBar = $GameUI/Buttons/Bag/MarginContainer/AirProgress

var light_flickering = false

var has_ui_open = false
var cookie_maker_cooldown = false
var is_hard_mode = false
var is_game_over = false
var is_door_closed = false
var is_bag_down = false
var must_wait_until_air_full = false
var jackson_cooldown = false

var air: float = 100.0
var time = 0

var pengu_sound_range: FloatRange = FloatRange.new(2.5, 7.5)
var rand_sound_range: FloatRange = FloatRange.new(3.0, 7.0)
var flicker_range: FloatRange = FloatRange.new(1.5, 9.0)

var available_pengu_sounds: Array[Resource] = PENGU_SOUNDS.duplicate()

var current_map: Map
var current_cookie_maker: CookieMaker

func _ready() -> void:
	GameSettings.reset()
	SceneFade.enable_blinking()
	
	update_cookies()
	
	$Timers/GameDurationTimer.wait_time = GameSettings.GAME_DURATION_SECONDS
	$Timers/HourTimer.wait_time = GameSettings.HOUR_DURATION
	$Timers/GameDurationTimer.start()
	$Timers/HourTimer.start()
	
	sound_timer.start(rand_sound_range.rand())
	light_timer.start(flicker_range.rand())
	
	pengu_sound_timer.start(pengu_sound_range.rand())
	
	pengu_updated(pengu_ai.current_pos)
	pengus_cookies_updated(pengu_ai.cookie_controller.cookies)
	pengu_ai.cookie_controller.cookies_updated.connect(pengus_cookies_updated)

func _process(delta: float) -> void:
	if is_bag_down:
		air -= GameSettings.AIR_DECREASE * delta
	else:
		air += GameSettings.AIR_INCREASE * delta
	air = clampf(air, 0.0, 100.0)
	air_progress.value = air
	
	if air <= 0.0:
		must_wait_until_air_full = true
		is_bag_down = false
		bag_up()
		air_progress.add_theme_stylebox_override("fill", PROGRESS_FILLED_RED)
	elif air >= 100.0 and must_wait_until_air_full:
		print("Air refilled")
		must_wait_until_air_full = false
		air_progress.add_theme_stylebox_override("fill", PROGRESS_FILLED_WHITE)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var inst = PAUSE_SCREEN.instantiate()
		add_child(inst)

func game_over() -> void:
	is_game_over = true
	print("Game Over!")
	$Timers/HourTimer.stop()
	time = GameSettings.GAME_DURATION_HOURS
	game_hour_passed()
	
	pengu_ai.stop()
	cookie_controller.stop()
	pengu_sound_timer.stop()
	random_sound.stop()
	pengu_sound.stop()
	
	get_tree().change_scene_to_file("res://scenes/game/win_screen/win_screen.tscn")

func init_hard_mode():
	SceneFade.blink()
	await SceneFade.blink_halfway
	is_hard_mode = true
	$Shudders.visible = true
	$Sounds/Starving.play()
	pengu_updated(pengu_ai.current_pos)
	SceneFade.disable_blinking()
	GameSettings.set_hard()

func game_hour_passed() -> void:
	if is_game_over:
		return
	time += 1
	time_label.text = str(time) + ":00"
	
	if time == GameSettings.HARD_MODE_START:
		$Sounds/GrandfatherClock.play()
		await $Sounds/GrandfatherClock.finished
		init_hard_mode()
	else:
		$Sounds/ClockTickSound.play()

func jumpscare(type: Jumpscare.JUMPSCARE_TYPES) -> void:
	is_game_over = true
	var inst: Jumpscare = JUMPSCARE.instantiate()
	inst.jumpscare_type = type
	get_tree().root.add_child(inst)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = inst
	#get_tree().change_scene_to_file("res://scenes/game/jumpscare/jumpscare.tscn")

func start_minigame() -> bool:
	if current_map:
		close_map()
	
	jackson_cooldown = false
	jackson_ai.cancel()
	
	trashy.minigame_start()
	
	var inst: StarvingMinigame = BEHIND_MINIGAME.instantiate()
	add_child(inst)
	await inst.minigame_completed
	
	trashy.minigame_end()
	
	if inst.failed:
		jumpscare(Jumpscare.JUMPSCARE_TYPES.PENGU)
		return false
	else:
		inst.queue_free()
		return true

func pengu_updated(pos: Utils.PENGU_POSITIONS) -> void:
	var new_texture: Resource
	if PENGU_VISUALS.has(pos):
		if is_hard_mode:
			if pos != Utils.PENGU_POSITIONS.DOOR and pos != Utils.PENGU_POSITIONS.TABLE:
				new_texture = null
			else:
				new_texture = PENGU_VISUALS.get(pos)
		else:
			new_texture = PENGU_VISUALS.get(pos)
	
	$PenguVisual.texture = new_texture
	
	if current_map:
		current_map.update()
	
	if pos == Utils.PENGU_POSITIONS.DOOR:
		feed_button.disabled = false
	else:
		feed_button.disabled = true

func pengus_cookies_updated(cookies: int) -> void:
	pengu_cookie_label.text = ": " + str(cookies)


func update_cookies() -> void:
	cookie_label.text = cookie_controller.format()
	
	if cookie_controller.is_empty():
		if is_door_closed:
			open_door()
		if current_map != null:
			close_map()

func close_door() -> void:
	cookie_controller.increase_rate(GameSettings.DOOR_RATE_INCREASE)
	$Sounds/DoorClose.play()
	is_door_closed = true

	var tween := create_tween()
	tween.tween_property($Door, "modulate:a", 1.0, .1)

func open_door() -> void:
	cookie_controller.decrease_rate(GameSettings.DOOR_RATE_INCREASE)
	is_door_closed = false
	
	var tween := create_tween()
	tween.tween_property($Door, "modulate:a", 0.0, .1)

func toggle_door(closed: bool) -> void:
	if is_door_closed == closed: return
	if cookie_controller.is_empty(): return
	
	if closed:
		close_door()
	else:
		open_door()
	
	print("Door State: ", is_door_closed)

func _on_game_duration_timer_timeout() -> void:
	game_over()


func _on_hour_timer_timeout() -> void:
	game_hour_passed()


func _on_sound_timer_timeout() -> void:
	random_sound.stream = RANDOM_SOUNDS.pick_random()
	random_sound.play()
	await random_sound.finished
	sound_timer.start(rand_sound_range.rand())


func _on_light_timer_timeout() -> void:
	if light_flickering:
		return
	light_flickering = true
	$Background.texture = GAME_BG_LIGHTOFF
	$Sounds/FlickerSound.play()
	light_timer.wait_time = randf_range(.05, 1)
	light_timer.start()
	await light_timer.timeout
	$Background.texture = GAME_BG
	light_flickering = false
	light_timer.start(flicker_range.rand())

func _on_pengu_sound_timer_timeout() -> void:
	if available_pengu_sounds.is_empty():
		print("Empty sounds, replacing")
		available_pengu_sounds = PENGU_SOUNDS.duplicate()
	var randomInt := randi_range(0, available_pengu_sounds.size()-1)
	pengu_sound.stream = available_pengu_sounds[randomInt]
	pengu_sound.play()
	
	available_pengu_sounds.remove_at(randomInt)
	
	await pengu_sound.finished
	pengu_sound_timer.start(pengu_sound_range.rand())

func close_map() -> void:
	if !current_map: return
	current_map.queue_free()
	current_map = null
	$MapCover.visible = false
	cookie_controller.decrease_rate(GameSettings.LOCATOR_RATE_INCREASE)
	$Sounds/LocatorClose.play()
	
	%Buttons.visible = true
	has_ui_open = false
	trashy.disable_moving()

func open_map() -> void:
	var inst: Map = MAP.instantiate()
	inst.pengu_ai = pengu_ai
	add_child(inst)
	current_map = inst
	$MapCover.visible = true
	cookie_controller.increase_rate(GameSettings.LOCATOR_RATE_INCREASE)
	$Sounds/LocatorOpen.play()
	
	has_ui_open = false
	%Buttons.visible = false
	
	if jackson_ai.is_attacking:
		print("Locator open with Jackson")
		jackson_ai.attack()
		%JacksonSmile.modulate.a = 0.0
		jackson_cooldown = true

		close_map()
		
		await get_tree().create_timer(4.8).timeout
		jackson_cooldown = false
		jackson_ai.after()
	else:
		trashy.enable_moving()

func _on_locator_button_mouse_entered() -> void:
	if jackson_cooldown: return
	if current_cookie_maker != null: return
	if is_bag_down: return
	if cookie_controller.is_empty(): return
	if current_map == null:
		open_map()
	elif current_map != null:
		close_map()


func _on_pengu_ai_position_updated() -> void:
	pengu_updated(pengu_ai.current_pos)


func _on_door_toggle_button_down() -> void:
	if jackson_cooldown: return
	if has_ui_open: return
	if is_bag_down: return
	toggle_door(!is_door_closed)


func _on_feed_button_button_down() -> void:
	if is_door_closed or pengu_ai.has_been_fed:
		return

	if pengu_ai.cookie_controller.cookies >= GameSettings.PENGU_MAX_COOKIES:
		print("He is full")
		return

	var pengu_hunger := GameSettings.PENGU_MAX_COOKIES - pengu_ai.cookie_controller.cookies
	var feed_amount := cookie_controller.get_cookies_to_feed(pengu_hunger)
	
	if feed_amount <= 0: return
	
	print("Feeding Pengu: ", feed_amount)

	cookie_controller.remove_cookies(feed_amount)
	pengu_ai.feed(feed_amount)

func _on_cookie_controller_cookies_updated(_cookies: int) -> void:
	update_cookies()

func bag_up() -> void:
	is_bag_down = false
	$Sounds/BagUp.play()
	$AnimationPlayer.play_backwards("bag")
	
	#trashy.disable_moving()

func bag_down() -> void:
	is_bag_down = true
	if current_map:
		close_map()
	
	#trashy.enable_moving()
	
	$AnimationPlayer.play("bag")
	$Sounds/BagDown.play()

func _on_bag_toggle_button_down() -> void:
	if jackson_cooldown: return
	if has_ui_open: return
	if must_wait_until_air_full: return
	is_bag_down = !is_bag_down
	if is_bag_down:
		bag_down()
	else:
		bag_up()


func _on_trashy_stop_button_down() -> void:
	if is_bag_down: return
	var success = trashy.go_away()
	if success:
		$Sounds/HitTrashy.play()

func close_cookie_maker() -> void:
	%Buttons.visible = true
	%LocatorButton.visible = true
	current_cookie_maker.queue_free()
	current_cookie_maker = null
	has_ui_open = false
	%TrashyStop.visible = true

func open_cookie_maker() -> void:
	var inst: CookieMaker = COOKIE_MAKER.instantiate()
	
	var is_enabled = false
	if cookie_controller.cookies <= 35:
		is_enabled = true
	
	inst.is_active = is_enabled
	inst.completed.connect(func():
		print("Awarding Cookies")
		cookie_maker_cooldown = true
		cookie_controller.add_cookies(GameSettings.COOKIE_REWARD)
		close_cookie_maker()
	)
		
	$CMCont.add_child(inst)
	current_cookie_maker = inst
	has_ui_open = true
	%Buttons.visible = false
	%TrashyStop.visible = false
	%LocatorButton.visible = false

func _on_cookie_button_button_down() -> void:
	if jackson_cooldown: return
	if current_cookie_maker:
		close_cookie_maker()
	else:
		open_cookie_maker()

func go_away_jackson() -> void:
	pass

func _on_jackson_ai_jackson_attack() -> void:
	print("Jackson attacking")
	var tween := create_tween()
	tween.tween_property(%JacksonSmile, "modulate:a", .4, .1)
	
	var dur = 2.5
	if is_hard_mode:
		dur = 1.5
	
	await get_tree().create_timer(dur).timeout
	if jackson_ai.is_attacking:
		%JacksonSmile.modulate.a = 0.0
		jackson_ai.cancel()
