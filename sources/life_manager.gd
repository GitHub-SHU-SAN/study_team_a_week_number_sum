extends Control

@onready var life_node: Sprite2D = $Life
@onready var life_2_node: Sprite2D = $Life2

var life_value:int = 2

func change_life() -> void:
	life_value -= 1
	match life_value:
		2:
			life_node.frame = 0
			life_2_node.frame = 0
		1:
			life_node.frame = 0
			life_2_node.frame = 1
		0:
			life_node.frame = 1
			life_2_node.frame = 1
