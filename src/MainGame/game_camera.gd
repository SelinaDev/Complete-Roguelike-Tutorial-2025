extends Camera2D


func _ready() -> void:
	CameraStateStack.position_changed.connect(_on_camera_state_position_changed)
	CameraStateStack.zoom_changed.connect(_on_camrea_state_zoom_changed)
	_on_camera_state_position_changed(CameraStateStack.get_position())
	_on_camrea_state_zoom_changed(CameraStateStack.get_zoom())


func _on_camera_state_position_changed(new_position: Vector2) -> void:
	position = new_position


func _on_camrea_state_zoom_changed(new_zoom: int) -> void:
	zoom = Vector2.ONE * new_zoom
