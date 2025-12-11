extends Control
class_name CookieMaker

const BAR = preload("uid://cfd2vushe61th")

@export var cookie_controller: CookieController

var bars: Array[CookieMakerBar] = []
var progresses: Array[float] = []
var acceptable_ranges: Array = []

var current_down = null
var is_active = true

func _ready() -> void:
	print("Init CookieMaker")
	for i in GameSettings.TOTAL_BARS:
		print("\tCreating Bar: ", i)
		
		var a_range = create_range()
		
		var inst: CookieMakerBar = BAR.instantiate()
		
		inst.acceptable_range = a_range
		inst.start_fill.connect(start_fill.bind(i))
		inst.end_fill.connect(end_fill.bind(i))
		
		bars.append(inst)
		progresses.append(0.0)
		acceptable_ranges.append(a_range)
		
		$ProgressBars.add_child(inst)

func _process(delta: float) -> void:
	var in_range = 0
	
	if is_active:
		for i in bars.size():
			var current_progress = progresses.get(i)
			var bar = bars.get(i)
			var acceptable_range = acceptable_ranges.get(i)
			
			if current_down == i:
				current_progress += GameSettings.FILL_INCREASE_RATE * delta
			else: 
				current_progress -= GameSettings.FILL_DECREASE_RATE * delta
			
			current_progress = clampf(current_progress, 0.0, 100.0)
			
			if current_progress > acceptable_range[0] and current_progress < acceptable_range[1]:
				in_range += 1
			
			progresses.set(i, current_progress)
			
			bar.set_progress(current_progress)
	#print(in_range)
	if in_range >= bars.size():
		print("ALL READY!!!")

func create_range() -> Array[float]:
	var max_r = randf_range(GameSettings.FILL_RANGE + randf_range(5.0, 7.5), 100.0 - randf_range(12.5, 15.0))
	var min_r = max_r - GameSettings.FILL_RANGE
	
	if min_r < 0.0:
		var up = abs(min_r) + 5.0
		min_r += up
		max_r += up
	
	return [min_r, max_r]

func start_fill(bar: int) -> void:
	current_down = bar

func end_fill(_bar: int) -> void:
	current_down = null
