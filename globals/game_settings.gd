extends Node

const HOUR_DURATION:int = 1
const GAME_DURATION_HOURS: int = 3
const GAME_DURATION_SECONDS: int = GAME_DURATION_HOURS * HOUR_DURATION

const START_COOKIES: int = 60
var COOKIE_LOSS_INVERVAL: FloatRange = FloatRange.new(.5, 2)
