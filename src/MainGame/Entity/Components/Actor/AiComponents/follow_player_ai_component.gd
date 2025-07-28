class_name FollowPlayerAiComponent
extends AiComponent

@export var persistence: int = 5
@export_storage var path: Array[Vector2i]
@export_storage var last_known_player_position: Vector2i
@export_storage var turns_remaining: int = 0


func get_proposed_actions(entity: Entity, target_player: Entity) -> Array[ProposedAction]:
	var position: Vector2i = PositionComponent.get_entity_position(entity)
	var player_in_sight: bool = entity.map_data.is_in_fov(position)
	if player_in_sight:
		turns_remaining = persistence
		last_known_player_position = PositionComponent.get_entity_position(target_player)
	else:
		turns_remaining = maxi(0, turns_remaining - 1)
		if turns_remaining == 0:
			return []
	path = entity.map_data.pathfinder.get_id_path(position, last_known_player_position)
	path.pop_front()
	if path.is_empty():
		return []
	var next_position: Vector2i = path.front()
	return [
		ProposedAction.new().with_priority(ProposedAction.Priority.LOW).with_score(5).with_action(
			MovementAction.new(entity, next_position - position)
		)
	]
