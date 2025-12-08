extends Node
class_name CookieController

signal cookies_updated(cookies: int)

@export var cookies: int = GameSettings.START_COOKIES
@export var min_time: float = .2
@export var max_time: float = 1

@onready var cookie_timer: Timer = $CookieTimer

var stopped = false

func _ready() -> void:
	cookie_timer.start(randf_range(min_time, max_time))

func get_cookies_to_feed(pengu_hunger: int) -> int:
	var feed_amount := mini(
		GameSettings.COOKIES_TO_FEED,
		mini(pengu_hunger, cookies)
	)
	return feed_amount

func stop() -> void:
	stopped = true
	cookie_timer.stop()

func is_empty() -> bool:
	return cookies <= 0

func increase_rate(by: float) -> void:
	min_time /= by
	max_time /= by

func decrease_rate(by: float) -> void:
	min_time *= by
	max_time *= by

func remove_cookies(cookies_to_remove: int = 1) -> void:
	cookies -= cookies_to_remove
	cookies = maxi(cookies, 0)
	cookies_updated.emit(cookies)

func format() -> String:
	return ": " + str(cookies)

func _on_cookie_timer_timeout() -> void:
	if stopped: return
	remove_cookies()
	cookie_timer.start(randf_range(min_time, max_time))
