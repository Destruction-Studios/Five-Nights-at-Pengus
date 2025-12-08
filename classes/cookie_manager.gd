extends Node
class_name CookieManager

signal cookies_updated(cookies: int)

var cookies: int = GameSettings.START_COOKIES

func get_cookies() -> int:
	return cookies

func add_cookie():
	cookies += 1
	cookies_updated.emit(cookies)

func is_empty() -> bool:
	if cookies <= 0:
		return true
	return false

func remove_cookie():
	cookies -= 1
	if cookies <= 0:
		cookies = 0
	cookies_updated.emit(cookies)
