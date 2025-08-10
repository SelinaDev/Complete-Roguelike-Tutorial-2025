class_name UseTargetSelf
extends UseTarget


func get_targets(user: Entity) -> Array[Entity]:
	await _wait_a_tick()
	return [user]
