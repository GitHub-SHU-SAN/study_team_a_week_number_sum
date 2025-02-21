extends GridContainer

var grid_scene = preload("res://scenes/grid_scene.tscn")
@onready var chara_live_2d: Node2D = $"../../CharaLive2D"

@onready var complete_screen: Control = $"../../CompleteScreen"


var grid_head_node = []

@onready var audio_line_correct: AudioStreamPlayer2D = $"/root/Node/AudioLineCorrect"
@onready var audio_complete: AudioStreamPlayer2D = $"../../AudioComplete"


func _ready() -> void:
	var main_node = get_parent().get_parent()
	main_node.signal_create_grid.connect(_on_signal_create_grid)


func _create_grid(_num:int, _value:int, _type:String, _correct:String) -> void:
	var grid_node = grid_scene.instantiate()
	grid_node._create_label(_num, _value, _type, columns, _correct)
	grid_node.signal_correct_check.connect(_on_signal_correct_check)
	add_child(grid_node)
	if _type == "answer":
		grid_head_node.append(grid_node)


func _on_signal_create_grid(_grid_size, _row_target, _col_target, _row_target_indices, _num_grid ) -> void:
	columns = _grid_size + 1
	grid_head_node = []

	var target_indices := []

	for row_index in range(_grid_size):
		var row = []
		for col_index in range(_grid_size):
			row.append(0)
		target_indices.append(row)

	for row_index in range(_row_target_indices.size()):
		for col_index in _row_target_indices[row_index]:
			if col_index < _grid_size:
				target_indices[row_index][col_index] = 1

	for idx in _col_target:
		_create_grid(0, idx, "answer", "")
	_create_grid(0, 0, "empty", "") # グリッドの右上、空の部分用

	var num := 1
	for row_index in range(_grid_size):
		for col_index in range(_grid_size):
			if target_indices[row_index][col_index] == 1:
				_create_grid(num, _num_grid[row_index][col_index], "number", "correct")
			else:
				_create_grid(num, _num_grid[row_index][col_index], "number", "incorrect")
			if col_index == _grid_size - 1:
				_create_grid(0, _row_target[row_index], "answer", "")
			num += 1


func _on_signal_correct_check(_node: Node) -> void:
	chara_live_2d.change_motion("笑顔")
	if _node.is_correct:
		var row_all_correct := true
		var col_all_correct := true
		var row_index = _node.row_index
		var col_index = _node.col_index
		var row_group = get_tree().get_nodes_in_group("row_group" + str(row_index))
		var col_group = get_tree().get_nodes_in_group("col_group" + str(col_index))

		for group_node in row_group:
			if group_node.is_correct:
				if not group_node.check_correct():
					row_all_correct = false
					break

		for group_node in col_group:
			if group_node.is_correct:
				if not group_node.check_correct():
					col_all_correct = false
					break

		if row_all_correct:
			grid_head_node[row_index + columns - 1].lock_correct_head()
			audio_line_correct.play()
		if col_all_correct:
			grid_head_node[col_index].lock_correct_head()
			audio_line_correct.play()

		var correct_complete = true
		for idx in grid_head_node:
			if not idx.check_lock():
				correct_complete = false
				break
		if correct_complete:
			complete_screen.show_compscreen()
