extends AnimationPlayer


func _ready() -> void:
	play("アイドル")


func change_motion(_name: StringName) -> void:
	match _name:
		"アイドル":
			play("アイドル")
		"くびふり":
			play("くびふり")
		"がっかり":
			play("がっかり")
