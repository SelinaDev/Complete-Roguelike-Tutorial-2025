class_name CameraState
extends RefCounted

const MAX_ZOOM = 8

signal grid_position_changed(new_grid_position)
signal zoom_changed(new_zoom)

var grid_position: Vector2i:
	set(value):
		grid_position = value
		grid_position_changed.emit(grid_position)
var zoom: int = 1:
	set(value):
		zoom = clampi(value, 1, MAX_ZOOM)
		zoom_changed.emit(zoom)


func derive() -> CameraState:
	var derived_state := CameraState.new()
	derived_state.grid_position = grid_position
	derived_state.zoom = zoom
	return derived_state
