extends Node2D

# グリッド生成シグナル
signal signal_create_grid

# 乱数の生成
var rng = RandomNumberGenerator.new()

# 初期シード
@export var puzzle_seed := 12345678
@onready var NumberLineEdit = $Control/LineEdit
@onready var LineEditRegEx = RegEx.new()

@onready var control: Control = %Control
@onready var life_manager: Control = $LifeManager
@onready var hint_manager: Control = $HintManager
@onready var chara_live_2d: Node2D = $CharaLive2D
@onready var complete_screen: Control = $CompleteScreen


var old_text = str(puzzle_seed)
var grid_size = 3


func _ready() -> void:
	create_puzzle("new")
	LineEditRegEx.compile("^[0-9a-z]*$")


func generate_puzzle(seed_val: int, min_val: int, max_val: int) -> Dictionary:

	if typeof(seed_val) != TYPE_INT:
		print("シード値は整数である必要があります。")
		return {}

	if min_val > max_val:
		print("最小値は最大値以下である必要があります。")
		return {}

	var size = grid_size

	rng.seed = seed_val + (grid_size * 10000000)
	NumberLineEdit.text = str(seed_val)

	var grid = []
	for idx in range(grid_size):
		grid.append([])
		for jdx in range(grid_size):
			grid[idx].append(rng.randi_range(min_val, max_val)) # rngを使って乱数を生成

	var row_targets = []
	var row_target_indices = []
	for row in range(grid_size):
		var target = 0
		var num_to_add = rng.randi_range(1, grid_size)
		var indices_to_add = []

		while indices_to_add.size() < num_to_add:
			var index = rng.randi_range(0, grid_size - 1)
			if not indices_to_add.has(index):
				indices_to_add.append(index)

		var current_row_indices = []
		for idx in indices_to_add:
			target += grid[row][idx]
			current_row_indices.append(idx)
		row_targets.append(target)
		row_target_indices.append(current_row_indices)

	var col_targets = []
	var col_target_indices = []
	for col in range(grid_size):
		var target = 0
		var indices_to_add = []

		# 対応する行のインデックスを取得
		for idx in range(row_target_indices.size()): # インデックスでループ
			var row_indices = row_target_indices[idx]
			for jdx in range(row_indices.size()): # 行のインデックスリスト内をループ
				if row_indices[jdx] == col: # 列のインデックスが行のインデックスに含まれているか確認
					indices_to_add.append(idx) # 行番号を記録
					break # 行のインデックスリスト内で一致するものを1つ見つければOK

		if indices_to_add.is_empty(): # 関連する行がない場合はランダムに選択
			var num_to_add = rng.randi_range(1, grid_size)
			while indices_to_add.size() < num_to_add:
				var index = rng.randi_range(0, grid_size - 1)
				if not indices_to_add.has(index):
					indices_to_add.append(index)

		var current_col_indices = []
		for idx in indices_to_add:
			target += grid[idx][col]
			current_col_indices.append(idx)
		col_targets.append(target)
		col_target_indices.append(current_col_indices)

	for idx in row_target_indices.size():
		row_target_indices[idx].sort()

	var puzzle = {
		"size": grid_size,
		"grid": grid,
		"row_targets": row_targets,
		"col_targets": col_targets,
		"row_target_indices": row_target_indices, # インデックスリストを追加
		"col_target_indices": col_target_indices, # インデックスリストを追加
		"seed": seed_val
	}

	return puzzle


func set_puzzle():

	# 例：パズルを生成 (最小値1、最大値9)
	var puzzle_data = generate_puzzle(puzzle_seed, 1, 9)

	signal_create_grid.emit(puzzle_data["size"], puzzle_data["row_targets"], puzzle_data["col_targets"], puzzle_data["row_target_indices"], puzzle_data["grid"])

	#if not puzzle_data.is_empty():
		#print("パズル生成成功:")
		#print("サイズ:", puzzle_data["size"])
		#print("グリッド:")
		#for row in puzzle_data["grid"]:
			#print(row)
		#print("行の目標値:", puzzle_data["row_targets"])
		#print("行の目標値に使用したインデックス:", puzzle_data["row_target_indices"])
		#print("列の目標値:", puzzle_data["col_targets"])
		#print("列の目標値に使用したインデックス:", puzzle_data["col_target_indices"])
		#print("シード値:", puzzle_data["seed"])
	#else:
		#print("パズル生成失敗")


func _on_button_pressed() -> void:
	create_puzzle("new")


func _on_text_edit_text_changed(new_text: String) -> void:
	if new_text.length() > 8:
		NumberLineEdit.text = old_text
		NumberLineEdit.set_caret_column(NumberLineEdit.text.length())
	elif LineEditRegEx.search(new_text):
		old_text = str(new_text)
	else:
		NumberLineEdit.text = old_text
		NumberLineEdit.set_caret_column(NumberLineEdit.text.length())


func _on_menu_button_item_selected(index: int) -> void:
	grid_size = index + 3


func _on_button_2_pressed() -> void:
	complete_screen.hide_compscreen()
	create_puzzle("rnd")


func create_puzzle(_mode) -> void:
	var _seed_length = old_text.length()
	if _seed_length > 0:
		for grid in get_tree().get_nodes_in_group("grid_group"):
			grid.get_parent().remove_child(grid)
		if _mode == "new":
			puzzle_seed = int(old_text)
		else:
			rng.seed = Time.get_ticks_msec()
			puzzle_seed = rng.randi_range(10000000, 99999999)
			old_text = str(puzzle_seed)
		set_puzzle()
		control.toggle_mode = false
		control.update_toggle_visibility()
		life_manager.set_life(0)
		hint_manager.set_hint(0)
		chara_live_2d.change_anim("アイドル")
		chara_live_2d.change_motion("まばたき")
