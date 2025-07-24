class_name PositionComponent
extends Component


@export_storage var position: Vector2i:
	set(value):
		var old_position := position
		position = value
		if _parent_entity:
			var message := Message.new("position_update").with_data({"position": position, "old_position": old_position})
			_parent_entity.process_message(message)


func process_message_precalculate(message: Message) -> void:
	match message.type:
		"move":
			var destination: Vector2i = message.data.get("destination", position)
			var destination_tile: Tile = _parent_entity.map_data.tiles.get(destination)
			if destination_tile == null or destination_tile.blocks_movement:
				destination = position
			message.data["destination"] = destination


func process_message_execute(message: Message) -> void:
	match message.type:
		"move" :
			var old_position := position
			position = message.data.get("destination", position)
			message.flags["did_perform_move"] = old_position != position
		"exit_map":
			_parent_entity.remove_component(type)


# implements Manhattan distance
func distance_to(other: Vector2i) -> int:
	var diff: Vector2i = (other - position).abs()
	return diff.x + diff.y


func get_component_type() -> Type:
	return Type.Position
