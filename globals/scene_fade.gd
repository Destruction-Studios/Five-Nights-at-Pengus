extends CanvasLayer

signal transition_halfway
signal blink_halfway

@onready var scene_transition: ColorRect = $SceneTransition

var skip_emit: bool = false

func _ready() -> void:
	scene_transition.modulate.a = 0.0

func transition() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(scene_transition, "modulate:a", 1.0, .5)
	
	tween.tween_callback(transition_halfway.emit)
	
	tween.tween_interval(0.1)
	
	tween.tween_property(scene_transition, "modulate:a", 0.0, 2)


func transition_to_file(file: String) -> void:
	transition()
	await transition_halfway
	get_tree().change_scene_to_file(file)

func blink() -> void:
	$AnimationPlayer.play("blink")

func _emit_b_halfway() -> void:
	blink_halfway.emit()
