extends Control

signal signal_marking_mode(mode)

@onready var toggle_on: TextureRect = $ToggleOn
@onready var toggle_off: TextureRect = $ToggleOff

@onready var audio_button_enable: AudioStreamPlayer2D = $"/root/Node/AudioButtonEnable"
@onready var audio_button_disable: AudioStreamPlayer2D = $"/root/Node/AudioButtonDisable"

var toggle_mode: bool = true
var hint_mode: bool = false

func _ready() -> void:
	update_toggle_visibility()


func _on_toggle_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if hint_mode:
				return

			toggle_mode = !toggle_mode
			update_toggle_visibility()
			if toggle_mode:
				audio_button_enable.play()
			else:
				audio_button_disable.play()
			signal_marking_mode.emit(toggle_mode)


func send_signal(_value) -> void:
	if _value == 2:
		hint_mode = true
		signal_marking_mode.emit(_value)
	else:
		hint_mode = false
		signal_marking_mode.emit(toggle_mode)


func update_toggle_visibility() -> void:
	toggle_on.visible = !toggle_mode
	toggle_off.visible = toggle_mode
