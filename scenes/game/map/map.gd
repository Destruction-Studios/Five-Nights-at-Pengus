extends Control
class_name Map

@onready var blink_timer: Timer = $BlinkTimer

var pengu_ai: PenguAI

func _ready():
	update()

func update() -> void:
	var locators: Array[Node] = get_tree().get_nodes_in_group("locator")
	var required_name: String = "pos_" + str(pengu_ai.current_pos)
	for rect: TextureRect in locators:
		if rect.name != required_name:
			rect.visible = false
		else:
			rect.visible = true


func _on_blink_timer_timeout() -> void:
	for item: TextureRect in get_tree().get_nodes_in_group("locator"):
		if !item.visible:
			continue
		var a = 0
		if item.modulate.a == 0: a = 1
		item.modulate.a = a
