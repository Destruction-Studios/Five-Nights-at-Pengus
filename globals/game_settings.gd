extends Node

#GAME
const HOUR_DURATION: int = 60
const GAME_DURATION_HOURS: int = 6
const GAME_DURATION_SECONDS: int = GAME_DURATION_HOURS * HOUR_DURATION

#COOKIES
const START_COOKIES: int = 60
var COOKIE_LOSS_INVERVAL: FloatRange = FloatRange.new(.5, 2)

#AI
const MIN_MOVE_TIME: float = 1.0
const MAX_MOVE_TIME: float = 2.0
const ATTACK_CHANCE: int = 3
const MOVE_CHANCE: int = 1
const BEHIND_CHANCE: int = 2
