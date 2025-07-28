class_name MeleeAiComponent
extends AiComponent


func get_proposed_actions(entity: Entity, target_player: Entity) -> Array[ProposedAction]:
	var player_position := PositionComponent.get_entity_position(target_player)
	var position_component: PositionComponent = entity.get_component(Component.Type.Position)
	if position_component.distance_to(player_position) <= 1:
		return [
			ProposedAction.new().with_priority(ProposedAction.Priority.MEDIUM).with_score(10).with_action(
				MeleeAction.new(entity, player_position - position_component.position)
			)
		]
	return []
