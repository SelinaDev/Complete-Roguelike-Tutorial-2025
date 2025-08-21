class_name TakeStairsAction
extends Action


func perform() -> bool:
	var entity_position: Vector2i = PositionComponent.get_entity_position(_performing_entity)
	var stairs: Array[Entity] = _performing_entity.map_data.get_entities_at_position(entity_position).filter(
		func(e: Entity) -> bool: return e.has_component(Component.Type.Stairs)
	)
	if stairs.is_empty():
		Log.send_log(
			"There are no stairs at %s's location." % _performing_entity.get_entity_name(),
			Log.COLOR_IMPOSSIBLE
		)
		return false
	var stairs_component: StairsComponent = stairs.front().get_component(Component.Type.Stairs)
	_performing_entity.map_data.new_map_requested.emit(stairs_component.target_floor)
	return true
