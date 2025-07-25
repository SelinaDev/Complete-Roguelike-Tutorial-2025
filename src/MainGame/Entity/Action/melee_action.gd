class_name MeleeAction
extends ActionWithDirection

func perform() -> bool:
	var target: Entity = get_blocking_entity_at_destination()
	if not target or target == _performing_entity:
		return false
	
	print("%s hits %s" % [_performing_entity.name, target.name])
	return true
