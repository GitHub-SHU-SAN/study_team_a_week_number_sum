extends Control

signal signal_marking_mode(mode)

@onready var toggle_on: TextureRect = $ToggleOn
@onready var toggle_off: TextureRect = $ToggleOff

var toggle_mode: bool = false

func _ready() -> void:
	update_toggle_visibility()


func _on_toggle_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			toggle_mode = !toggle_mode
			update_toggle_visibility()
			signal_marking_mode.emit(toggle_mode)


func update_toggle_visibility() -> void:
	toggle_on.visible = !toggle_mode
	toggle_off.visible = toggle_mode
