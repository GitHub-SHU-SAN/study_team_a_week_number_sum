extends Control

var main_node: Node
@onready var audio_complete: AudioStreamPlayer2D = $"../AudioComplete"
@onready var chara_live_2d: Node2D = $"../CharaLive2D"


func _ready() -> void:
	main_node = $"/root/Node"


func show_compscreen() -> void:
	audio_complete.play()
	chara_live_2d.change_anim("くびふり")
	show()


func hide_compscreen() -> void:
	hide()
