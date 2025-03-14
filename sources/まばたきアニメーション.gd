extends AnimationPlayer

var is_idle: bool = true
var stop_emotion: bool = false


func _ready() -> void:
	randomize()
	play_mabataki()


func play_mabataki() -> void:
	if stop_emotion:
		return
	var timing = randi_range(1, 8)
	await get_tree().create_timer(timing).timeout
	if is_idle:
		play("まばたき")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "まばたき":
		play_mabataki()


func change_motion(_name: StringName) -> void:
	stop_emotion = false
	match _name:
		"笑顔":
			is_idle = false
			play("笑顔")
		"おどろき":
			is_idle = false
			play("おどろき")
		"まばたき":
			is_idle = true
			play("まばたき")


func stop_motion() -> void:
	stop_emotion = true
