class_name RememberableComponent
extends Component


@export var remember_color: Color = Color.GRAY
@export_storage var seen: bool = false


func process_message_precalculate(message: Message) -> void:
	match message.type:
		"position_update", "fov_update":
			if seen:
				message.data["remember_color"] = remember_color


func process_message_execute(message: Message) -> void:
	match message.type:
		"fov_update":
			var fov: Dictionary[Vector2i, bool] = message.data.get("fov", {})
			var position: Vector2i = message.data.get("position", Vector2i(-1, -1))
			var is_in_view: bool = fov.get(position, false)
			seen = is_in_view or seen


func get_component_type() -> Type:
	return Type.Rememberable
