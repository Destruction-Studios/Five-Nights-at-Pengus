extends Control
class_name Jumpscare

enum JUMPSCARE_TYPES {
	PENGU,
	TRASHY
}

const PENGU_IMAGES = [
	preload("res://assets/images/game/jumpscare/up.png"),
	preload("res://assets/images/game/jumpscare/right.png"),
	preload("res://assets/images/game/jumpscare/left.png")
]
const TRASHY_IMAGES = [
	preload("res://assets/images/game/jumpscare/hand.png")
]

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var images
var jumpscare_type: JUMPSCARE_TYPES

func _ready() -> void:
	var flicker_tween := create_tween()
	flicker_tween.set_loops()
	flicker_tween.tween_property($Background, "color", Color("9a9a9a"), .05)
	flicker_tween.tween_property($Background, "color", Color.BLACK, .05)
	
	if jumpscare_type == JUMPSCARE_TYPES.PENGU:
		images = PENGU_IMAGES
		$JumpscareImage.texture = images[0]
		pengu(flicker_tween)
	elif jumpscare_type == JUMPSCARE_TYPES.TRASHY:
		images = TRASHY_IMAGES
		$JumpscareImage.texture = images[0]
		trashy(flicker_tween)
	else:
		push_error("Invalid jumpscare type: ", jumpscare_type)

func pengu(flicker_tween: Tween) -> void:
	$Text.visible = false
	
	animation_player.play("jumpscare_pengu")
	
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

func trashy(flicker_tween: Tween) -> void:
	$Text.visible = false
	
	animation_player.play("jumpscare_trashy")
	
	await animation_player.animation_finished
	
	animation_player.stop()
	flicker_tween.kill()
	$JumpscareImage.visible = false
	$Timer.stop()
	
	var tween := create_tween()
	tween.tween_property($Background, "color", Color.SKY_BLUE, 1)
	$Static.play()
	
	$AnimationPlayer.play("text")
	$Text.visible = true
 
func _on_timer_timeout() -> void:
	$JumpscareImage.texture = images.pick_random()


func _on_menu_button_down() -> void:
	Transitions.transition_to_file("res://scenes/menu/menu.tscn")
