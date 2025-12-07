extends Node
class_name IntRange

var myMin: int = 0
var myMax: int = 0

func _init(_min: int, _max: int):
	myMin = _min
	myMax = _max

func rand() -> int:
	return randi_range(myMin, myMax)

func get_min() -> int:
	return myMin

func get_max() -> int:
	return myMax
