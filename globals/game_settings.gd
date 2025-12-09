extends Node

#GAME
const HOUR_DURATION: int = 60
const GAME_DURATION_HOURS: int = 6
const GAME_DURATION_SECONDS: int = GAME_DURATION_HOURS * HOUR_DURATION

#COOKIES
const START_COOKIES: int = 12000
const LOCATOR_RATE_INCREASE = 3
const DOOR_RATE_INCREASE = 6
const COOKIES_TO_FEED = 10

#AI
const PENGU_MAX_COOKIES = 18
const MIN_MOVE_TIME: float = 1.0
const MAX_MOVE_TIME: float = 4.5
const MOVE_SUCCESS_TIME_MULTI: float = 1.5
const ATTACK_CHANCE: int = 3
const MOVE_CHANCE: int = 1
var ATTACK_DELAY: FloatRange = FloatRange.new(2.0, 5.0)

#Minigame
const MINIGAME_DURATION = 20 #seconds
const BUMP_OFFSET = Vector2(150, 75)
const START_PROGRESS = 20
const PROGRESS_INCREASE = 15
const PROGRESS_DECREASE = 17
var BUMP_RANGE: FloatRange = FloatRange.new(.2, 1.5)

func reset() -> void:
	pass
