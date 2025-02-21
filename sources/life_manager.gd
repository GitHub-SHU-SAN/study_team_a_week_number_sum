extends Control

@onready var audio_fall_correct: AudioStreamPlayer2D = $"../AudioFallCorrect"
@onready var chara_live_2d: Node2D = $"../CharaLive2D"


var main_node: Node
var game_over_node: Node

var life_value:int = 3
var live_sprite_nodes: Array


func _ready() -> void:
	main_node = $"/root/Node"
	game_over_node = $"/root/Node/GameOverScreen"


func set_life(_mode) -> void:
	if live_sprite_nodes != null:
		for idx in live_sprite_nodes.size():
			live_sprite_nodes[idx].queue_free()
	live_sprite_nodes.clear()

	match _mode:
		0:
			life_value = 4
		1:
			life_value = 3
		2:
			life_value = 2
	create_life(life_value)


func create_life(_value) -> void:
	for idx in _value:
		var sprite_node = Sprite2D.new()
		live_sprite_nodes.append(sprite_node)
		sprite_node.texture = preload("res://images/life.png")
		sprite_node.hframes = 2
		sprite_node.frame = 0
		sprite_node.position = Vector2(62 * idx, 24)
		add_child(sprite_node)


func change_life() -> void:
	life_value -= 1
	audio_fall_correct.play()
	chara_live_2d.change_motion("おどろき")
	if !live_sprite_nodes:
		return
	for idx in live_sprite_nodes.size():
		if life_value - 1 >= idx:
			live_sprite_nodes[idx].frame = 0
		else:
			live_sprite_nodes[idx].frame = 1
	if life_value == 0:
		game_over_node.show_gameoverscreen()
