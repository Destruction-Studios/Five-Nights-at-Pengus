extends Control

const IMAGES = [
	preload("res://assets/images/game/jumpscare/up.png"),
	preload("res://assets/images/game/jumpscare/right.png"),
	preload("res://assets/images/game/jumpscare/left.png")
]

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	$Text.visible = false
	
	var flicker_tween := create_tween()
	flicker_tween.set_loops()
	flicker_tween.tween_property($Background, "color", Color("9a9a9a"), .05)
	flicker_tween.tween_property($Background, "color", Color.BLACK, .05)
	
	animation_player.play("jumpscare")
	
	await animation_player.animation_finished
	
	animation_player.stop()
	flicker_tween.kill()
	$JumpscareImage.visible = false
	$Timer.stop()
	
	var tween := create_tween()
	tween.tween_property($Background, "color", Color.RED, 1)
	$Static.play()
	
	$AnimationPlayer.play("text")
	$Text.visible = true


func _on_timer_timeout() -> void:
	$JumpscareImage.texture = IMAGES.pick_random()


func _on_menu_button_down() -> void:
	Transitions.transition_to_file("res://scenes/menu/menu.tscn")
