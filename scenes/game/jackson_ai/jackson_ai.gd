extends Node
class_name JacksonAI

signal jackson_attack
@onready var attack_timer: Timer = $Attack

var is_attacking = false

func _ready() -> void:
	#jumpscare()
	attack_timer.start(GameSettings.JACKSON_ATTACK_RANGE.rand())

func wait() -> void:
	if is_attacking: return
	is_attacking = true
	jackson_attack.emit()

func attack() -> void:
	$AnimationPlayer.play("jumpscoare")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("ouch")

func after() -> void:
	print("Jackson go bye")
	if is_attacking: return
	is_attacking = false
	var tween := create_tween()
	tween.tween_property($Image, "modulate:a", 0.0, 1.1)
	tween.tween_callback($AnimationPlayer.stop)
	
	print("Start j timer")
	attack_timer.start(GameSettings.JACKSON_ATTACK_RANGE.rand())

func cancel() -> void:
	if !is_attacking: return
	is_attacking = false
	$Image.modulate.a = 0.0
	$AnimationPlayer.play("RESET")

func _on_attack_timeout() -> void:
	wait()
