extends Control
class_name CookieMakerBar

signal start_fill
signal end_fill

const BAR_HEIGHT := 450.0

@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var range_label: ColorRect = $VBoxContainer/ProgressBar/Range

var acceptable_range: Array[float]
var height = BAR_HEIGHT

func scale_number(num: float) -> float:
	return (num / 100.0) * height

func _ready() -> void:
	var h = progress_bar.size.y

	var min_px = (acceptable_range[0] / 100.0) * h
	var max_px = (acceptable_range[1] / 100.0) * h

	# invert because bar visual fills from bottom
	var inv_min = h - max_px
	var inv_max = h - min_px

	range_label.position.y = inv_min
	range_label.size.y = inv_max - inv_min


func _on_button_button_down() -> void:
	start_fill.emit()

func _on_button_button_up() -> void:
	end_fill.emit()

func set_progress(progress: float) -> void:
	progress_bar.value = progress
