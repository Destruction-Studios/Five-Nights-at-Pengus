extends CanvasLayer

signal transition_halfway
signal blink_halfway

@onready var scene_transition: ColorRect = $SceneTransition

var skip_emit: bool = false
static var blinking_enabled: bool = true

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

func disable_blinking() -> void:
	blinking_enabled = false

func enable_blinking() -> void:
	blinking_enabled = true

func blink() -> void:
	if !blinking_enabled:
		call_deferred("_emit_b_halfway")
		return
	$AnimationPlayer.play("blink_new")

func _emit_b_halfway() -> void:
	blink_halfway.emit()
