extends Control

var main_node: Node
@onready var audio_game_over: AudioStreamPlayer2D = $"../AudioGameOver"
@onready var chara_live_2d: Node2D = $"../CharaLive2D"


func _ready() -> void:
	main_node = $"/root/Node"


func show_gameoverscreen() -> void:
	audio_game_over.play()
	chara_live_2d.change_anim("がっかり")
	show()


func hide_gameoverscreen() -> void:
	hide()



func _on_button_pressed() -> void:
	main_node.create_puzzle("new")
	hide()
