class_name UseTargetNearest
extends UseTarget

@export var max_range: int = 1
@export var max_targets: int = 1
@export var target_component_type: Component.Type = Component.Type.Durability


func get_targets(user: Entity) -> Array[Entity]:
	await _wait_a_tick()
	var user_position_component: PositionComponent = user.get_component(Component.Type.Position)
	var targets_map : Dictionary[Entity, int] = {}
	for entity: Entity in user.map_data.get_entities_with_components([Component.Type.Position, target_component_type]):
		if entity == user:
			continue
		var entity_distance: int = user_position_component.distance_to(PositionComponent.get_entity_position(entity))
		if entity_distance > max_range:
			continue
		targets_map[entity] = entity_distance
	var targets: Array[Entity] = targets_map.keys()
	targets.sort_custom(func(a: Entity, b: Entity) -> bool: return targets_map[a] < targets_map[b])
	targets = targets.slice(0, max_targets)
	return targets
