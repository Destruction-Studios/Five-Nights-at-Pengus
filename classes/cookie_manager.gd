extends Node
class_name CookieManager

signal cookies_updated(cookies: int)
signal cookies_depleted

var cookies: int = 0

func add_cookie():
	cookies += 1
	cookies_updated.emit(cookies)

func remove_cookie():
	cookies -= 1
	if cookies <= 0:
		cookies_depleted.emit()
		cookies = 0
	cookies_updated.emit(cookies)
