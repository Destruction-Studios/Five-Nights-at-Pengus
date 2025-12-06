extends CanvasLayer

signal transition_halfway

@onready var color_rect: ColorRect = $ColorRect

var skip_emit: bool = false

func _ready() -> void:
	color_rect.modulate.a = 0.0

func transition() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, .5)
	
	tween.tween_callback(transition_halfway.emit)
	
	tween.tween_interval(0.1)
	
	tween.tween_property(color_rect, "modulate:a", 0.0, 2)


func transition_to_scene(packed: PackedScene) -> void:
	SceneFade.transition()
	await transition_halfway
	get_tree().change_scene_to_packed(packed)
