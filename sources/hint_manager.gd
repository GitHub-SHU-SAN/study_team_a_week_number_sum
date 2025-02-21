extends Control

var main_node: Node
@onready var control: Control = %Control
@onready var audio_hint: AudioStreamPlayer2D = $"../AudioHint"


var hint_value:int = 3
var hint_sprite_nodes: Array
var is_hint_mode: bool = false


func _ready() -> void:
	main_node = $"/root/Node"


func set_hint(_mode:int) -> void:
	clear_massage()
	if hint_sprite_nodes != null:
		for idx in hint_sprite_nodes.size():
			hint_sprite_nodes[idx].queue_free()
	hint_sprite_nodes.clear()

	match _mode:
		0:
			hint_value = 4
		1:
			hint_value = 3
		2:
			hint_value = 2
	create_hint(hint_value)


func create_hint(_value) -> void:
	for idx in _value:
		var sprite_node = Sprite2D.new()
		hint_sprite_nodes.append(sprite_node)
		sprite_node.texture = preload("res://images/hint.png")
		sprite_node.hframes = 2
		sprite_node.frame = 0
		sprite_node.position = Vector2(62 * idx, 24)
		add_child(sprite_node)

	
func change_hint() -> void:
	if hint_value == 0:
		return
	hint_value -= 1
	#audio_fall_correct.play()
	if !hint_sprite_nodes:
		return
	for idx in hint_sprite_nodes.size():
		if hint_value - 1 >= idx:
			hint_sprite_nodes[idx].frame = 0
		else:
			hint_sprite_nodes[idx].frame = 1


func clear_massage() -> void:
	$"../Message/SuccLabel".hide()
	$"../Message/FallLabel".hide()
	$"../Message/HintLabel".hide()
	$"../Message/HintLabel2".hide()


func no_hint() -> void:
	$"../Message/SuccLabel".hide()
	$"../Message/FallLabel".hide()
	$"../Message/HintLabel".hide()
	$"../Message/HintLabel2".show()


func check_grid() -> void:
	$"../Message/HintLabel2".hide()
	$"../Message/SuccLabel".hide()
	$"../Message/FallLabel".hide()
	$"../Message/HintLabel".show()


func succ_hint() -> void:
	change_hint()
	control.send_signal(0)
	is_hint_mode = false
	$"../Message/HintLabel2".hide()
	$"../Message/HintLabel".hide()
	$"../Message/FallLabel".hide()
	$"../Message/SuccLabel".show()


func fall_hint() -> void:
	change_hint()
	control.send_signal(0)
	is_hint_mode = false
	$"../Message/HintLabel2".hide()
	$"../Message/HintLabel".hide()
	$"../Message/SuccLabel".hide()
	$"../Message/FallLabel".show()


func _on_button_pressed() -> void:
	if is_hint_mode:
		return
	else:
		is_hint_mode = true
		if hint_value > 0:
			check_grid()
			control.send_signal(2)
			audio_hint.play()
		else:
			no_hint()
