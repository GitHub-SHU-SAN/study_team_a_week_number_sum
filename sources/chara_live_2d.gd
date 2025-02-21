extends Node2D

@onready var eye_anim: AnimationPlayer = $"PolygonNodes/頭/目アニメーション"
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func change_motion(_name: StringName) -> void:
	eye_anim.change_motion(_name)


func change_anim(_name: StringName) -> void:
	animation_player.change_motion(_name)
