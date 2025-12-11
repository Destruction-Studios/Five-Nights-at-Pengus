extends Node
class_name FloatRange

var d_mi: float = 0
var d_ma: float = 0

var myMin: float = 0
var myMax: float = 0

func _init(_min: float, _max: float):
	myMin = _min
	myMax = _max
	
	d_mi = _min
	d_ma = _max

func reset() -> void:
	myMax = d_ma
	myMin = d_mi

func decrease(amt: float) -> void:
	myMax /= amt
	myMin /= amt

func increase(amt: float) -> void:
	myMax *= amt
	myMin *= amt

func rand() -> float:
	return randf_range(myMin, myMax)

func get_min() -> float:
	return myMin

func get_max() -> float:
	return myMax
