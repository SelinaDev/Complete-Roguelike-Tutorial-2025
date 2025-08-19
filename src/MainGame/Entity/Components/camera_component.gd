class_name CameraComponent
extends Component


var _camera_state: CameraState


func _enter_entity() -> void:
	_obtain_camera_state()


func _obtain_camera_state() -> void:
	_camera_state = CameraStateStack.get_new_state()


func process_message_execute(message: Message) -> void:
	match message.type:
		"position_update":
			_camera_state.grid_position = message.data.get("position")
		"zoom_in":
			_camera_state.zoom += 1
		"zoom_out":
			_camera_state.zoom -= 1
		"reactivate":
			_obtain_camera_state()
			_camera_state.grid_position = message.data.get("position")


func get_component_type() -> Type:
	return Type.Camera
