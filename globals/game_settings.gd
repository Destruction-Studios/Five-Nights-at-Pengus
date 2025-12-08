extends Node

#GAME
const HOUR_DURATION: int = 60
const GAME_DURATION_HOURS: int = 6
const GAME_DURATION_SECONDS: int = GAME_DURATION_HOURS * HOUR_DURATION

#COOKIES
const START_COOKIES: int = 120
var COOKIE_LOSS_INVERVAL: FloatRange = FloatRange.new(.5, 2)
const LOCATOR_RATE_INCREASE = 2.5
const DOOR_RATE_INCREASE = 4
const COOKIES_TO_FEED = 10

#AI
const PENGU_START_COOKIES = 10
const PENGU_MAX_COOKIES = 18
const MIN_MOVE_TIME: float = 2.5
const MAX_MOVE_TIME: float = 5.0
const ATTACK_CHANCE: int = 3
const MOVE_CHANCE: int = 1
const BEHIND_CHANCE: int = 3
var MOVE_TO_START_DELAY: FloatRange = FloatRange.new(2.0, 10.0)
