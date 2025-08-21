class_name PickupAction
extends Action


func perform() -> bool:
	var entity_position: Vector2i = PositionComponent.get_entity_position(_performing_entity)
	var items: Array[Entity] = _performing_entity.map_data.get_entities_at_position(entity_position).filter(
		func(e: Entity) -> bool: return e.has_component(Component.Type.Item)
	)
	if items.is_empty():
		Log.send_log(
			"Nothing to pick up at %s's location." % _performing_entity.get_entity_name(),
			Log.COLOR_IMPOSSIBLE
		)
		return false
	var message := Message.new("take_item").with_data({
		"item": items.front(),
		"verb": "pick up",
		"verb_past_tense": "picked up"
	})
	_performing_entity.process_message(message)
	return message.flags.get("did_take_item", false)
