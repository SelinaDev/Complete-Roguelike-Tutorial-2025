class_name BumpAction
extends ActionWithDirection

func perform() -> bool:
	var blocking_entity := get_blocking_entity_at_destination()
	
	if blocking_entity:
		return MeleeAction.new(_performing_entity, offset).perform()
	return MovementAction.new(_performing_entity, offset).perform()
