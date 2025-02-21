extends CenterContainer

signal signal_correct_check(node)

@onready var control_node: Control = $"/root/Node/Control"
@onready var camera_2d: Camera2D =  $"/root/Node/Camera2D"
@onready var life_manager: Control = $"/root/Node/LifeManager"
@onready var hint_manager: Control = $"/root/Node/HintManager"


@onready var color_rect: ColorRect = $ColorRect
@onready var success_node: TextureRect = $ColorRect/success
@onready var fall_node: TextureRect = $ColorRect/fall
@onready var button_node: Button

@onready var audio_success_correct: AudioStreamPlayer2D = $"/root/Node/AudioSuccessCorrect"

var is_correct: bool = false
var is_lock: bool = false

var grid_number: int = 0
var row_index: int = 0
var col_index: int = 0

enum MARK_STATES {
	NONE,
	SUCCESS,
	FALL,
	HINT,
}

var mark_state: MARK_STATES = MARK_STATES.SUCCESS


func _ready() -> void:
	control_node.signal_marking_mode.connect( _on_toggle_mode)


func _create_label(_num:int, _value:int, _type:String, _col, _correct:String) -> void:
	button_node = Button.new()

	var grid_fit_size = 600 / _col
	grid_number = _num


	# 軸のグループ化
	if _num > 0:
		row_index = (_num - 1) / (_col - 1)
		col_index = (_num - 1) % (_col - 1)
		add_to_group("row_group" + str(row_index))
		add_to_group("col_group" + str(col_index))

	if _correct == "correct":
		is_correct = true

	$ColorRect.custom_minimum_size = Vector2(grid_fit_size, grid_fit_size)
	$ColorRect/success.size = Vector2(grid_fit_size, grid_fit_size)
	$ColorRect/fall.size = Vector2(grid_fit_size, grid_fit_size)

	_setup_button(button_node, _value, _type, _col)
	add_child(button_node)


func _setup_button(button: Button, _value: int, _type: String, _col: int) -> void: 
	var button_fit_size = 640 / _col
	button.flat = true
	button.custom_minimum_size = Vector2(button_fit_size, button_fit_size)
	button.add_theme_font_size_override("font_size", 36)
	button.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	button.set("theme_override_colors/font_color", Color(255, 255, 255))
	button.add_theme_constant_override("outline_size", 8)
	button.set("theme_override_styles/focus", StyleBoxEmpty.new())

	if _type != "empty":
		button.text = str(_value)

	if _type == "number":
		button.connect("pressed", _on_button_node_pressed)
	else:
		$ColorRect.set_color(Color(0.65, 0.65, 0.68, 0.98))


func _on_button_node_pressed() -> void:
	if button_node.disabled:
		return

	hint_manager.clear_massage()

	if mark_state == MARK_STATES.HINT:
		if is_correct:
			hint_manager.succ_hint()
		if !is_correct:
			hint_manager.fall_hint()
	elif mark_state == MARK_STATES.SUCCESS:
		if is_correct:
			button_node.modulate = Color(255, 255, 255, 0.3)
			button_node.disabled = true
			success_node.visible = true
			fall_node.visible = false
			signal_correct_check.emit(self)
			audio_success_correct.play()
		else:
			success_node.visible = true
			fall_node.visible = false
			camera_2d.shake_mode = true
			life_manager.change_life()
			await get_tree().create_timer(0.2).timeout
			success_node.visible = false
	elif mark_state == MARK_STATES.FALL:
		success_node.hide()
		fall_node.visible = !fall_node.visible


func _on_toggle_mode(_toggle_mode:int) -> void:
	match _toggle_mode:
		0:
			mark_state = MARK_STATES.SUCCESS
		1:
			mark_state = MARK_STATES.FALL
		2:
			mark_state = MARK_STATES.HINT


func check_correct() -> bool:
	if is_correct && success_node.visible:
		return is_correct
	return !is_correct


func check_lock() -> bool:
	return is_lock


func lock_correct_head() -> void:
	is_lock = true
	button_node.modulate = Color(255, 255, 255, 0.4)
	color_rect.modulate = Color(255, 255, 255, 0.4)
	
