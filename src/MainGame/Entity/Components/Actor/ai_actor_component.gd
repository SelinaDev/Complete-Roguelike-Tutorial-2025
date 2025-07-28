class_name AiActorComponent
extends ActorComponent

@export var ai_components: Array[AiComponent]


func _enter_entity() -> void:
	super._enter_entity()
	var duplicated_components: Array[AiComponent] = []
	for ai_component: AiComponent in ai_components:
		duplicated_components.append(ai_component.duplicate(true))
	ai_components = duplicated_components


func get_action() -> Action:
	_parent_entity.process_message(Message.new("get_action"))
	return super.get_action()


func process_message_precalculate(message: Message) -> void:
	match message.type:
		"get_action":
			var player_entity: Entity = _parent_entity.map_data.player_entity
			for ai_component: AiComponent in ai_components:
				message.data\
					.get_or_add("proposed_actions", [])\
					.append_array(
						ai_component.get_proposed_actions(_parent_entity, player_entity)
					)


func process_message_execute(message: Message) -> void:
	super.process_message_execute(message)
	match message.type:
		"get_action":
			var proposed_actions: Array = message.data.get("proposed_actions", [])
			var proposed_action: ProposedAction = proposed_actions.reduce(
				func(action: ProposedAction, current_action: ProposedAction) -> ProposedAction:
					if current_action.priority > action.priority:
						return current_action
					elif current_action.priority < action.priority:
						return action
					return current_action if current_action.score > action.score else action,
					ProposedAction.new().with_action(WaitAction.new(_parent_entity)).with_priority(ProposedAction.Priority.FALLBACK)
			)
			_queued_action = proposed_action.action
