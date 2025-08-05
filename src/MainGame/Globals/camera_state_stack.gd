extends Node

var _TILE_SIZE: Vector2 = ProjectSettings.get_setting("global/tile_size")

signal position_changed(new_position)
signal zoom_changed(new_zoom)

var _stack: Array[CameraState]


func get_new_state() -> CameraState:
	var new_state: CameraState
	if _stack.is_empty():
		new_state = CameraState.new()
	else:
		var top_state: CameraState = _stack.back()
		new_state = top_state.derive()
		top_state.grid_position_changed.disconnect(_on_top_state_position_changed)
		top_state.zoom_changed.disconnect(_on_top_state_zoom_changed)
	
	_stack.append(new_state)
	new_state.grid_position_changed.connect(_on_top_state_position_changed)
	new_state.zoom_changed.connect(_on_top_state_zoom_changed)
	
	return new_state


func pop_state() -> void:
	var top_state: CameraState = _stack.pop_back()
	if top_state:
		top_state.grid_position_changed.disconnect(_on_top_state_position_changed)
		top_state.zoom_changed.disconnect(_on_top_state_zoom_changed)
	if not _stack.is_empty():
		var new_top_state: CameraState = _stack.back()
		new_top_state.grid_position_changed.connect(_on_top_state_position_changed)
		new_top_state.zoom_changed.connect(_on_top_state_zoom_changed)
		_stack.back().activate()
		


func get_position() -> Vector2:
	var grid_position := Vector2.ZERO
	if not _stack.is_empty():
		grid_position = _stack.back().grid_position
	return _grid_to_world(grid_position)


func get_zoom() -> int:
	return 2 if _stack.is_empty() else _stack.back().zoom


func _on_top_state_position_changed(new_grid_position: Vector2i) -> void:
	position_changed.emit(_grid_to_world(new_grid_position))


func _on_top_state_zoom_changed(new_zoom: int) -> void:
	zoom_changed.emit(new_zoom)


func _grid_to_world(grid_position: Vector2i) -> Vector2:
	return Vector2(grid_position) * _TILE_SIZE
