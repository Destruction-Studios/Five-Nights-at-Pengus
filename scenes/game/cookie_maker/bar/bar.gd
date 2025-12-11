extends Control
class_name CookieMakerBar

signal start_fill
signal end_fill

@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var range_label: ColorRect = $VBoxContainer/ProgressBar/Range

var acceptable_range: Array[float]

# BAR SIZE IS CHANGED CHANGE THIS!!!!!
static func scale_number(num: float) -> float:
	return 450.0/(100.0/num)

func _ready() -> void:
	print("\t\tSetting range: ", acceptable_range)
	range_label.size.y = GameSettings.FILL_RANGE
	range_label.position.y = scale_number(acceptable_range[1])

func _on_button_button_down() -> void:
	start_fill.emit()


func _on_button_button_up() -> void:
	end_fill.emit()

func set_progress(progress: float) -> void:
	progress_bar.value = progress
