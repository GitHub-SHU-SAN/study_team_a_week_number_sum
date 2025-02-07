extends GridContainer

var grid_scene = preload("res://scenes/grid_scene.tscn")

var grid_head_node = []


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

	var temp_target_indices := []
	var target_indices := []
	var target_index = 0
	
	for idx in _row_target_indices.size():
		for jdx in _row_target_indices[idx].size():
			temp_target_indices.append(_row_target_indices[idx][jdx])
	
	for idx in _grid_size:
		for jdx in _grid_size:
			if temp_target_indices.size() > target_index:
				if temp_target_indices[target_index] == jdx:
					target_indices.append(1)
					target_index += 1
				else:
					target_indices.append(0)
			else:
				target_indices.append(0)

	for idx in _col_target:
		_create_grid(0, idx, "answer", "")
	_create_grid(0, 0, "empty", "") # グリッドの右上、空の部分用

	var grid_data := []
	for _row in _num_grid:
		for _col in _row:
			grid_data.append(_col)

	var num := 1
	for _row in grid_data.size():
		if target_indices[_row] == 1:
			_create_grid(num, grid_data[_row], "number", "correct")
		else:
			_create_grid(num, grid_data[_row], "number", "incorrect")
		if _row % _grid_size == _grid_size - 1:
			_create_grid(0, _row_target[_row / _grid_size], "answer", "")
		num += 1


func _on_signal_correct_check(_node: Node) -> void:
	if _node.is_correct:
		var row_all_correct := true
		var col_all_correct := true
		var row_index = _node.row_index
		var col_index = _node.col_index
		var row_group = get_tree().get_nodes_in_group("row_group" + str(row_index))
		var col_group = get_tree().get_nodes_in_group("col_group" + str(col_index))
		#get_tree().call_group("row_group" + str(row_index), "correct_row")
		#get_tree().call_group("col_group" + str(col_index), "enter_alert_mode")

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
		if col_all_correct:
			grid_head_node[col_index].lock_correct_head()


func _ready() -> void:
	var main_node = get_parent().get_parent()
	main_node.signal_create_grid.connect(_on_signal_create_grid)
