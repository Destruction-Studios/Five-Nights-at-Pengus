extends Node
class_name FloatRange

var myMin: float = 0
var myMax: float = 0

func _init(_min: float, _max: float):
	myMin = _min
	myMax = _max

func rand() -> float:
	return randf_range(myMin, myMax)

func get_min() -> float:
	return myMin

func get_max() -> float:
	return myMax
